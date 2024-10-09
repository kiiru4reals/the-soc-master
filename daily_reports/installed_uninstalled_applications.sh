#!/bin/bash
installed_applications(){
    # Prompt the user for the input CSV file
    read -p "Enter the path to the CSV file (Installed applications) or 's' to skip: " input_file

    # Check if the user wants to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping processing of the CSV file."
        uninstalled_applications
        exit 0
    fi

    # Output file path
    output_file="../docs/installed_applications.csv"

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Step 1: Replace ';' with ',' and process the CSV
    temp_file="temp_processed.csv"

    awk -F, '{gsub(/;/, ",")}1' "$input_file" > "$temp_file"

    # Step 2: Count unique occurrences and prepare the output
    awk -F, '
    BEGIN {
        OFS = ",";
        print "Username,Src IP,Device IP,Dst IP,Destination,userdata5,count";
    }
    {
        # Create a unique key based on all relevant fields
        key = $1 OFS $2 OFS $3 OFS $4;
        
        # Increment the count for the unique key
        count[key]++;
        
        # Store the first occurrence of each field for the output
        if (!seen[key]++) {
            username[$1] = $1;
            src_ip[$2] = $2;
            dst_ip[$3] = $3;
            userdata5[$4] = $4;
        }
    }
    END {
        for (k in count) {
            split(k, fields, OFS);
            print username[fields[1]], src_ip[fields[2]], src_ip[fields[2]], dst_ip[fields[3]], dst_ip[fields[3]], userdata5[fields[4]], count[k];
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."


}

uninstalled_applications(){
    # Prompt the user for the input CSV file
    read -p "Enter the path to the CSV file (Installed applications) or 's' to skip: " input_file

    # Check if the user wants to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping processing of the CSV file."
        uninstalled_applications
        exit 0
    fi

    # Output file path
    output_file="../docs/uninstalled_applications.csv"

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Step 1: Replace ';' with ',' and process the CSV
    temp_file="temp_processed.csv"

    awk -F, '{gsub(/;/, ",")}1' "$input_file" > "$temp_file"

    # Step 2: Count unique occurrences and prepare the output
    awk -F, '
    BEGIN {
        OFS = ",";
        print "Username,Src IP,Device IP,Dst IP,Destination,userdata5,count";
    }
    {
        # Create a unique key based on all relevant fields
        key = $1 OFS $2 OFS $3 OFS $4;
        
        # Increment the count for the unique key
        count[key]++;
        
        # Store the first occurrence of each field for the output
        if (!seen[key]++) {
            username[$1] = $1;
            src_ip[$2] = $2;
            dst_ip[$3] = $3;
            userdata5[$4] = $4;
        }
    }
    END {
        for (k in count) {
            split(k, fields, OFS);
            print username[fields[1]], src_ip[fields[2]], src_ip[fields[2]], dst_ip[fields[3]], dst_ip[fields[3]], userdata5[fields[4]], count[k];
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."


}

installed_applications
uninstalled_applications