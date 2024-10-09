#!/bin/bash

# Configuration
read -p "Enter virus total API key: " API_KEY
INPUT_FILE="urls.csv"
TEMP_FILE="temp.csv"
FILTERED_FILE="filtered_hostnames.csv"
FLAGGED_FILE="../docs/flagged_domains.csv"


# Function to check if a hostname is an IP address
is_ip_address() {
  local hostname="$1"
  [[ "$hostname" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

# Remove timestamp column and keep only hostname
awk -F, '{print $2}' "$INPUT_FILE" | tail -n +2 > "$TEMP_FILE"

# Remove duplicates
sort -u "$TEMP_FILE" > "$FILTERED_FILE"

# Remove IP addresses
while IFS= read -r hostname; do
  if ! is_ip_address "$hostname"; then
    echo "$hostname"
  fi
done < "$FILTERED_FILE" > "$TEMP_FILE"

# Check each hostname with VirusTotal API and save flagged domains
> "$FLAGGED_FILE"  # Clear the flagged file
while IFS= read -r hostname; do
  echo "Checking $hostname..."
  response=$(curl -s -H "x-apikey: $API_KEY" "https://www.virustotal.com/api/v3/domains/$hostname")
  
  # Print the full API response for debugging purposes
#   echo "Response for $hostname:"
#   echo "$response"
  
  # Extract the malicious count
  malicious_count=$(echo "$response" | jq '.data.attributes.last_analysis_stats.malicious // 0')

  # Print the malicious count
  echo "Malicious count for $hostname: $malicious_count"

  if [ "$malicious_count" -ge 1 ]; then
    echo "$hostname" >> "$FLAGGED_FILE"
  fi
done < "$TEMP_FILE"

echo "Flagged domains saved to $FLAGGED_FILE"

# Clean up temporary files
rm "$TEMP_FILE" "$FILTERED_FILE"
