#!/bin/bash

usage() {
  echo "Usage: $0 -u URL"
  exit 1
}

while getopts u: flag
do
  case "${flag}" in
    u) url=${OPTARG};;
    *) usage;;
  esac
done

if [ -z "$url" ]; then
  usage
fi

IMAGE="
 +-+-+-+-+-+-+-+-+-+-+-+-+
 |c|r|a|w|w|w|l|e|r|.|s|h|
 +-+-+-+-+-+-+-+-+-+-+-+-+
"

echo "$IMAGE"

response=$(curl -sL --fail "$url")
if [ $? -ne 0 ]; then
  echo "Error: failed to download HTML page"
  exit 1
fi

links=$(echo "$response" | grep -oP '(?<=<a href=")[^"]*')

check_status() {
  local url=$1

  local code=$(curl -sL -o /dev/null -w "%{http_code}" "$url")

  if [ $code -eq 200 ]; then
    printf "%-100s \e[32m%s\e[0m\n" "${url:0:100}" "$code"
  else
    printf "%-100s \e[31m%s\e[0m\n" "${url:0:100}" "$code"
  fi
}

for link in $links; do
  if [[ $link =~ ^http[s]?:// ]]; then
    absolute_url=$link
  else
    absolute_url=$(echo "$url" | awk -F/ '{OFS="/"; NF--; print $0}')"/$link"
  fi

  check_status "$absolute_url"
done | tee "results_$(echo $url | sed 's/[^A-Za-z0-9_.-]/_/g').txt"

echo "--------------------------------------------------"
echo "You can find the results here: $(readlink -f "results_$(echo $url | sed 's/[^A-Za-z0-9_.-]/_/g').txt")"
echo "--------------------------------------------------"
