#!/bin/bash

# Define the usage instructions
usage() {
  echo "Usage: $0 [URL]"
  exit 1
}

# Check if the URL argument was provided
if [ -z "$1" ]; then
  usage
fi

# Define the ASCII art image
IMAGE="
 +-+-+-+-+-+-+-+-+-+-+-+-+
 |c|r|a|w|w|w|l|e|r|.|s|h|
 +-+-+-+-+-+-+-+-+-+-+-+-+
"

# Print the ASCII art image
echo "$IMAGE"

# Define the URL to crawl
url="$1"

# Download the HTML page from the website
response=$(curl -sL "$url")

# Check if curl was successful
if [ $? -ne 0 ]; then
  echo "Error: failed to download HTML page"
  exit 1
fi

# Extract all the links from the HTML page
links=$(echo "$response" | grep -oP '(?<=<a href=")[^"]*')

# Define a function to check the HTTP status code of a URL
check_status() {
  local url=$1

  # Get the HTTP status code of the URL
  local code=$(curl -sL -o /dev/null -w "%{http_code}" "$url")

  # Print the URL and its HTTP status code, truncating the URL to 100 characters
  if [ $code -eq 200 ]; then
    # Print the URL in green if the status code is 200
    printf "%-100s \e[32m%s\e[0m\n" "${url:0:100}" "$code"
  else
    # Print the URL in red if the status code is not 200
    printf "%-100s \e[31m%s\e[0m\n" "${url:0:100}" "$code"
  fi
}

# Loop through each link and check its HTTP status code
for link in $links; do

  # Check if the link is a relative or absolute URL
  if [[ $link =~ ^http[s]?:// ]]; then
    # The link is an absolute URL
    url=$link
  else
    # The link is a relative URL
    url="$url/$link"
  fi

  check_status "$url"
done | tee "results_$1.txt"

# Print the file path of the output file
echo "--------------------------------------------------"
echo "You can find the results here: $(readlink -f "results_$1.txt")"
echo "--------------------------------------------------"
