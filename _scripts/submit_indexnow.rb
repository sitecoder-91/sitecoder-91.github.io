#!/usr/bin/env ruby
require 'yaml'
require 'rexml/document'
require 'net/http'
require 'json'
require 'uri'

# Load _config.yml to get the site URL
config_path = File.expand_path('../_config.yml', __dir__)
unless File.exist?(config_path)
  puts "Error: _config.yml not found at #{config_path}"
  exit 1
end

config = YAML.load_file(config_path)
site_url = config['url']
if site_url.nil? || site_url.empty?
  puts "Error: 'url' is not defined in _config.yml"
  exit 1
end

# Strip trailing slash from site_url if present
site_url = site_url.chomp('/')
host = URI.parse(site_url).host

# Determine the IndexNow key
# First check for INDEXNOW_KEY environment variable.
key = ENV['INDEXNOW_KEY']

if key.nil? || key.empty?
  # Try to find a potential key file in the root directory
  root_dir = File.expand_path('..', __dir__)
  txt_files = Dir.glob(File.join(root_dir, "*.txt"))
  
  # IndexNow keys are typically 32-character hexadecimal strings
  potential_key_file = txt_files.find { |f| File.basename(f) =~ /\A[a-f0-9]{32}\.txt\z/i }
  
  if potential_key_file
    key = File.basename(potential_key_file, ".txt")
    puts "Found IndexNow key file: #{File.basename(potential_key_file)}"
  else
    puts "Error: INDEXNOW_KEY environment variable not set, and no 32-char hex key .txt file found in the root directory."
    puts "Please set the INDEXNOW_KEY environment variable or create your key file (e.g. <key>.txt) in the root directory."
    exit 1
  end
end

key_location = "#{site_url}/#{key}.txt"

# Locate sitemap.xml in _site/
sitemap_path = File.expand_path('../_site/sitemap.xml', __dir__)
unless File.exist?(sitemap_path)
  puts "Error: sitemap.xml not found at #{sitemap_path}."
  puts "Please build the Jekyll site first (e.g., bundle exec jekyll build) so that the sitemap is generated."
  exit 1
end

# Parse sitemap.xml
urls = []
begin
  file = File.new(sitemap_path)
  doc = REXML::Document.new(file)
  REXML::XPath.each(doc, '//loc') do |element|
    urls << element.text.strip
  end
rescue => e
  puts "Error parsing sitemap.xml: #{e.message}"
  exit 1
end

if urls.empty?
  puts "No URLs found in sitemap.xml."
  exit 1
end

puts "Found #{urls.size} URLs to submit."

# Submit to IndexNow
uri = URI.parse('https://www.bing.com/indexnow')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json; charset=utf-8'})
payload = {
  host: host,
  key: key,
  keyLocation: key_location,
  urlList: urls
}

request.body = payload.to_json

puts "Submitting URLs to IndexNow..."
response = http.request(request)

if response.code.to_i == 200
  puts "Success! URLs submitted successfully to IndexNow."
else
  puts "Failed to submit URLs. HTTP Status: #{response.code}"
  puts "Response: #{response.body}"
  exit 1
end
