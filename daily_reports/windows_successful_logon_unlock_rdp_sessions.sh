#!/bin/bash

windows_successful_logon_unlock(){
    # Prompt user for input CSV file path
    read -p "Enter the path to your CSV file: (Windows successful logon: Unlock), enter s to skip " input_file

    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Processing skipped."
        # exit 0
        rdp_sessions
    fi

    # Output file
    output_file="../docs/windows_successful_logon_unlock.csv"

    # Step 1: Clean the data by replacing ; with ,
    temp_file="temp_cleaned.csv"
    sed 's/;/,/g' "$input_file" > "$temp_file"

    # Step 2: Remove Date, Keep Time, and Add Count and Domain columns
    awk -F, '
    BEGIN {
        OFS=",";
        print "Time", "Src IP", "Dst IP", "Username", "Domain", "Count";
    }
    NR > 1 {
        # Extract time part from the Date GMT-4:00 column (first column)
        split($1, datetime, " ");
        time = datetime[2];

        # Determine the domain based on the third octet of Dst IP
        split($3, ip_parts, ".");
        third_octet = ip_parts[3];
        
        if (third_octet == 50 || third_octet == 60 || third_octet == 75 || third_octet == 80) {
            domain = "Z";
        } else if (third_octet == 100) {
            domain = "X";
        } else if (third_octet == 1 || third_octet == 0) {
            domain = "Y";
        } else {
            domain = "Unknown-domain";  # Fallback for any unexpected third octet values
        }

        # Store time, Src IP, Dst IP, Username and increment count for duplicates
        key = time "," $2 "," $3 "," $4 "," domain;
        count[key]++;
    }
    END {
        # Print the result with Time, Src IP, Dst IP, Username, Domain, and Count
        for (entry in count) {
            split(entry, fields, ",");
            print fields[1], fields[2], fields[3], fields[4], fields[5], count[entry];
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Clean up temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."
}

rdp_sessions(){
        # Prompt user for input CSV file path
    read -p "Enter the path to your CSV file: (RDP sessions), enter s to skip " input_file

    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Processing skipped."
        exit 0
    fi

    # Output file
    output_file="../docs/rdp_sessions.csv"

    # Step 1: Clean the data by replacing ; with ,
    temp_file="temp_cleaned.csv"
    sed 's/;/,/g' "$input_file" > "$temp_file"

    # Step 2: Remove Date, Keep Time, and Add Count and Domain columns
    awk -F, '
    BEGIN {
        OFS=",";
        print "Time", "Src IP", "Dst IP", "Username", "Domain", "Count";
    }
    NR > 1 {
        # Extract time part from the Date GMT-4:00 column (first column)
        split($1, datetime, " ");
        time = datetime[2];

        # Determine the domain based on the third octet of Dst IP
        split($3, ip_parts, ".");
        third_octet = ip_parts[3];
        
        if (third_octet == 50 || third_octet == 60 || third_octet == 75 || third_octet == 80) {
            domain = "Y";
        } else if (third_octet == 100) {
            domain = "Switchlink Africa";
        } else if (third_octet == 1 || third_octet == 0) {
            domain = "X";
        } else {
            domain = "Unknown-domain";  # Fallback for any unexpected third octet values
        }

        # Store time, Src IP, Dst IP, Username and increment count for duplicates
        key = time "," $2 "," $3 "," $4 "," domain;
        count[key]++;
    }
    END {
        # Print the result with Time, Src IP, Dst IP, Username, Domain, and Count
        for (entry in count) {
            split(entry, fields, ",");
            print fields[1], fields[2], fields[3], fields[4], fields[5], count[entry];
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Clean up temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."
}
windows_successful_logon_unlock
rdp_sessions