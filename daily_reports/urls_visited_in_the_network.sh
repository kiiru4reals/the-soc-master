#!/bin/bash

# Prompt the user for the input file path
    read -p "Enter the path to the input CSV file (URLs being visited): " input_file

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    echo "====================== Creating output file ============================"
    # Get the current date in dd_mm_yyyy format
    previous_date=$(date -d "yesterday" +%d_%m_%Y)

    # Define the output file name with the date appended
    output_file="../docs/clean_firewall_report_of_all_urls_visited_on_${previous_date}.csv"

    # Define temporary files
    temp_file="temp_urls.csv"
    sorted_file="sorted_urls.csv"

    # Count unique URLs and create the 'count' column
    awk -F, 'NR==1{next} {hostname_count[$2]++} END {for (hostname in hostname_count) print "", hostname, hostname_count[hostname]}' OFS=, "$input_file" > "$temp_file"

    # Add headers to the cleaned data
    sed -i '1s/^/timestamp,url,count\n/' "$temp_file"

    # Sort the data by the 'count' column (3rd column) in descending order
    sort -t, -k3,3nr "$temp_file" > "$sorted_file"

    # Save the sorted data to the final output file
    mv "$sorted_file" "$output_file"

    # Clean up temporary files
    rm "$temp_file"

    echo "Processed file saved as $output_file"
