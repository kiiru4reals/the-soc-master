#!/bin/bash

net_logon_business_hours(){
    # Prompt user for the input CSV file
    read -p "Enter the path to the net logon CSV file (or 's' to skip): " input_file

    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping the cleaning of the net logon file."
        net_logon_off_business_hours
        # return
    fi

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Step 1: Remove 2nd, 4th, and 5th columns, and keep the count from the original 3rd column
    output_file="cleaned_net_logon.csv"
    
    awk -F, 'BEGIN {
        OFS=",";
        print "computer_name,count"
    }
    {
        # Remove $ from the first column
        gsub(/\$/, "", $1);
        # Remove whitespace from the first column
        gsub(/[ \t]+/, "", $1);
        # Print cleaned first column and the original count from the third column
        print $1, $3;
    }' "$input_file" > "$output_file"

    echo "Cleaned net logon file created: $output_file"

    # Step 4: Request for the Graylog sample file
    read -p "Enter the path to the Graylog sample CSV file: " graylog_file

    # Check if the Graylog sample file exists
    if [[ ! -f "$graylog_file" ]]; then
        echo "Graylog sample file not found!"
        exit 1
    fi

    # Step 5: Merge data with the Graylog sample based on srcname
    final_output="../docs/net_logon_business_hours.csv"
    
    {
        echo "computer_name,unauthuser,srcip,count"
        while IFS=, read -r computer_name count; do
            # Check for matches in the Graylog file
            match=$(awk -F, -v srcname="$computer_name" '$1 == srcname {print $2","$3}' "$graylog_file")
            
            if [[ -n "$match" ]]; then
                echo "$computer_name,$match,$count"
            else
                echo "$computer_name,,,$count"
            fi
        done < <(tail -n +2 "$output_file")  # Skip the header in output_file
    } > "$final_output"

    echo "Final output has been saved to: $final_output"
    rm $output_file
}

net_logon_off_business_hours(){

    # Prompt the user for the input CSV file
    read -p "Enter the path to the CSV file containing computer names: (Network logon off business hours)" input_file

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Label the column and clean the file
    # Step 1: Remove the $ sign and create a temporary file
    temp_file="temp_computer_names.csv"
    awk '{gsub(/\$/, ""); print}' "$input_file" > "$temp_file"

    # Step 2: Count unique entries and create a new file with the count
    output_file="cleaned_computer_names.csv"
    awk -F, 'BEGIN { print "computer_name,count" }
            { count[$1]++ }
            END { for (name in count) print name "," count[name] }' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    # Step 4: Request the Graylog sample file
    read -p "Enter the path to the Graylog sample CSV file: " graylog_file

    # Check if the Graylog sample file exists
    if [[ ! -f "$graylog_file" ]]; then
        echo "Graylog sample file not found!"
        exit 1
    fi

    # Step 5: Merge data with the Graylog sample
    final_output="../docs/net_logon_off_business_hours.csv"
    {
        echo "computer_name,unauthuser,srcip,count"
        while IFS=, read -r computer_name count; do
            # Check for matches in the Graylog file
            match=$(awk -F, -v srcname="$computer_name" '$1 == srcname {print $2","$3}' "$graylog_file")
            
            if [[ -n "$match" ]]; then
                echo "$computer_name,$match,$count"
            else
                echo "$computer_name,,,$count"
            fi
        done < <(tail -n +2 "$output_file")  # Skip the header in output_file
    } > "$final_output"

    echo "Processing complete. The final output has been saved to $final_output."
    ./start.sh
}
net_logon_business_hours
net_logon_off_business_hours
