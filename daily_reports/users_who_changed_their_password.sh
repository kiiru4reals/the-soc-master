#!/bin/bash
        # Prompt user to upload the CSV file
    read -p "Please enter the path to your CSV file:  " input_file

    # Output file
    output_file="../docs/users_who_changed_their_password.csv"

    # Temporary file to store counts
    temp_file="temp_counted.csv"

    # Count occurrences of each unique entry in Userdata8 column
    awk -F, '
    BEGIN {
        OFS=",";
        # Print header with Count column
        print "Src IP", "Userdata8", "Count";
    }
    NR==1 {
        # Save header for later use
        header = $0;
        next;
    }
    {
        # Count occurrences of each unique entry in Userdata8
        count[$2]++;
    }
    END {
        # Reprint the header and include counts
        print header;
        while ((getline < FILENAME) > 0) {
            print $1, $2, count[$2];
        }
    }
    ' "$input_file" > "$temp_file"

    # Move temporary file to output file
    mv "$temp_file" "$output_file"

    echo "Processing complete. The output has been saved to $output_file."