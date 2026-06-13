#!/bin/bash
set -e

# Parse command-line options
CONFIRM=false
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -c|--confirm) CONFIRM=true ;;
    *) echo "Unknown parameter: $1" >&2; echo "Usage: $0 [-c|--confirm]" >&2; exit 1 ;;
  esac
  shift
done

# Load _config.yml to get site URL
if [ ! -f "_config.yml" ]; then
  echo "Error: _config.yml not found." >&2
  exit 1
fi

# Extract URL and strip quotes and trailing slashes
URL=$(grep -E "^url:" _config.yml | sed -e 's/url:[[:space:]]*//' -e 's/"//g' -e "s/'//g" | sed 's|/*$||')

if [ -z "$URL" ]; then
  echo "Error: 'url' configuration not found in _config.yml." >&2
  exit 1
fi

# Extract host from URL
HOST=$(echo "$URL" | sed -E 's|https?://([^/]+).*|\1|')

# Determine IndexNow Key
if [ -z "$INDEXNOW_KEY" ]; then
  # Find 32-character hexadecimal key text files in the root folder
  KEY_FILE=$(find . -maxdepth 1 -name "*.txt" | grep -E "/[0-9a-fA-F]{32}\.txt$" | head -n 1)
  if [ -n "$KEY_FILE" ]; then
    INDEXNOW_KEY=$(basename "$KEY_FILE" .txt)
    echo "Found IndexNow key file: $(basename "$KEY_FILE")"
  else
    echo "Error: INDEXNOW_KEY environment variable not set, and no 32-char hex key .txt file found in the root directory." >&2
    echo "Please set INDEXNOW_KEY or create a key file (e.g. <key>.txt) in the root directory." >&2
    exit 1
  fi
fi

KEY_LOCATION="${URL}/${INDEXNOW_KEY}.txt"

# Locate sitemap.xml
if [ ! -f "_site/sitemap.xml" ]; then
  echo "Error: _site/sitemap.xml not found." >&2
  echo "Please build the Jekyll site first (e.g., bundle exec jekyll build)." >&2
  exit 1
fi

# Extract URLs from sitemap
URLS=$(grep -o '<loc>[^<]*</loc>' _site/sitemap.xml | sed -e 's/<loc>//' -e 's/<\/loc>//')

if [ -z "$URLS" ]; then
  echo "Error: No URLs found in _site/sitemap.xml." >&2
  exit 1
fi

# Replace localhost/127.0.0.1 development URLs with the production URL
ESCAPED_URL=$(echo "$URL" | sed 's#[&/\]#\\&#g')
URLS=$(echo "$URLS" | sed -E "s#https?://(localhost|127\.0\.0\.1):[0-9]+#${ESCAPED_URL}#g")

# Count URLs
URL_COUNT=$(echo "$URLS" | grep -c '^')
echo "Found $URL_COUNT URLs to submit."

# Format URLs as JSON array elements
JSON_URLS=""
while read -r line; do
  if [ -n "$line" ]; then
    if [ -z "$JSON_URLS" ]; then
      JSON_URLS="\"$line\""
    else
      JSON_URLS="$JSON_URLS, \"$line\""
    fi
  fi
done <<< "$URLS"

# Construct payload JSON
TARGET_API="https://www.bing.com/indexnow"
PAYLOAD=$(cat <<EOF
{
  "host": "$HOST",
  "key": "$INDEXNOW_KEY",
  "keyLocation": "$KEY_LOCATION",
  "urlList": [
    $JSON_URLS
  ]
}
EOF
)

# User confirmation prompt if requested
if [ "$CONFIRM" = true ]; then
  echo "Target URL: $TARGET_API"
  echo "JSON Payload:"
  echo "$PAYLOAD"
  echo ""
  read -p "Do you want to submit these URLs to IndexNow? (y/N): " CONFIRM_ANSWER
  case "$CONFIRM_ANSWER" in
    [yY]|[yY][eE][sS])
      echo "Proceeding with submission..."
      ;;
    *)
      echo "Submission cancelled by user."
      exit 0
      ;;
  esac
fi

# Submit to IndexNow
echo "Submitting URLs to IndexNow..."
RESPONSE=$(curl -s -w "%{http_code}" -o response_body.txt \
  -X POST \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "$PAYLOAD" \
  "$TARGET_API")

if [ "$RESPONSE" -eq 200 ] || [ "$RESPONSE" -eq 202 ]; then
  echo "Success! URLs submitted successfully to IndexNow (Status $RESPONSE)."
  rm -f response_body.txt
else
  echo "Failed to submit URLs. HTTP Status: $RESPONSE" >&2
  if [ -f response_body.txt ]; then
    cat response_body.txt >&2
    echo "" >&2
    rm -f response_body.txt
  fi
  exit 1
fi

