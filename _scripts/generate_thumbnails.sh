#!/bin/bash

# Ensure output directory exists
mkdir -p assets/img/thumbnails

echo "Generating thumbnails..."

# Loop through all matching videos in assets/media
for video in assets/media/*.mp4 assets/media/*.mov assets/media/*.webm; do
  # Check if file exists to avoid literal pattern match issues
  [ -f "$video" ] || continue
  
  filename=$(basename "$video")
  name="${filename%.*}"
  
  echo "Extracting frame from $filename..."
  ffmpeg -y -i "$video" -ss 00:00:00.500 -vframes 1 -q:v 2 "assets/img/thumbnails/${name}.jpg"
done

echo "Done generating thumbnails."
