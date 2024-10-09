#!/bin/bash
echo "Never gonna give you up, never gonna let you down... (Okay, let's get back to work!)"
read -p "Enter the path to the input CSV file (or press 's' to skip): " input_file

# Check if the user wants to skip
if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
    echo "Skipping processing as requested."
    ./start.sh
    exit 
fi

# Check if the input file exists
if [[ ! -f "$input_file" ]]; then
    echo "Input file not found!"
    exit 1
fi

# Step 1: Replace all semicolons with commas in the CSV file
temp_file="temp_cleaned_file.csv"
sed 's/;/,/g' "$input_file" > "$temp_file"

# Define the output file name
output_file="../docs/windows_dc_logon_failure.csv"

# Step 2: Remove duplicates and count occurrences of Src IP
awk -F, 'NR>1 {count[$1]++} END {for (ip in count) print ip, count[ip]}' OFS=, "$temp_file" > "temp_ip_counts.txt"

# Step 3: Merge the count data with the original CSV, and keep only the first occurrence of each Src IP
awk -F, 'NR==FNR {counts[$1]=$2; next} FNR==1 {print $0",count"} FNR>1 && !seen[$1]++ {print $0","counts[$1]}' OFS=, "temp_ip_counts.txt" "$temp_file" > "$output_file"

# Step 4: Remove the temporary files
rm "temp_cleaned_file.csv" "temp_ip_counts.txt"

echo "Processed file saved as $output_file"