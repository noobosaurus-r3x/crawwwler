#!/bin/bash

# Define the ASCII art image
IMAGE="

 +-+-+-+-+-+-+-+-+-+-+-+-+
 |c|r|a|w|w|w|l|e|r|.|s|h|
 +-+-+-+-+-+-+-+-+-+-+-+-+

"

# Print the ASCII art image
echo "$IMAGE"

# Ask the user for the URL of the website to crawl
read -p "Enter the URL of the website to crawl: " url

# Make an HTTP request to the given URL and store the response in a variable
response=$(curl -L $url)

# Extract all the anchor tags from the HTML content
links=$(echo $response | grep -oP '(?<=<a href=")[^"]*')

# Iterate over the links and check if they are up or not
for link in $links; do
  # Make an HTTP request to the link and store the response code in a variable
  code=$(curl -L -s -o /dev/null -w "%{http_code}" $link)

  # Print the link and its status code
  echo "$link: $code"
done
