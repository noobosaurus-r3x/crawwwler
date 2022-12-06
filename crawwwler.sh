#!/bin/bash

# Define the ASCII art image
IMAGE="

 +-+-+-+-+-+-+-+-+-+-+-+-+
 |c|r|a|w|w|w|l|e|r|.|s|h|
 +-+-+-+-+-+-+-+-+-+-+-+-+

"

# Print the ASCII art image
echo "$IMAGE"

# Prompt the user to enter the URL of the website to crawl
read -p "Enter the URL of the website to crawl: " url

# Download the HTML page from the website
response=$(curl -sL "$url")

# Extract all the links from the HTML page
links=$(echo "$response" | grep -oP '(?<=<a href=")[^"]*')

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

  # Get the HTTP status code of the link
  code=$(curl -sL -o /dev/null -w "%{http_code}" "$url")

  # Print the URL and its HTTP status code, truncating the URL to 100 characters
  if [ $code -eq 200 ]; then
    # Print the URL in green if the status code is 200
    printf "%-100s \e[32m%s\e[0m\n" "${url:0:100}" "$code"
  else
    # Print the URL in red if the status code is not 200
    printf "%-100s \e[31m%s\e[0m\n" "${url:0:100}" "$code"
  fi
done
