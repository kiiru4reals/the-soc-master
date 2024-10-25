#!/bin/bash
privileged_operation_performed() {
    # Prompt user to enter the path to the input CSV file or skip
    read -p "Please enter the path to privileged operation performed CSV file (or type 's' to skip): " input_file

    # Allow user to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping processing of the CSV file."
        failed_attempts_to_perform_a_privileged_operation
    fi

    # Output file
    output_file="../docs/privileged_operation_performed.csv"

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Step 1: Replace all ; with , and save to a temporary file
    temp_file="temp_file.csv"
    tr ';' ',' < "$input_file" > "$temp_file"

    # Step 2: Process the temporary CSV file
    awk -F, '
    BEGIN {
        OFS=",";
        print "Username", "Source IP", "Source", "Destination IP", "Domain", "Count";
    }
    NR==1 {
        # Read the header line, skip it
        next;
    }
    {
        # Count the occurrences of each username
        count[$1]++;

        # Store the data
        src[$1]=$2;
        ip[$1]=$3;
        destination[$1]=$4;
    }
    END {
        # Print the final output
        for (user in count) {
            # Extract the third octet from the Destination IP
            split(destination[user], ip_parts, ".");
            third_octet = ip_parts[3];

            # Determine the domain based on the third octet
            if (third_octet == 1) {
                domain = "X-1";
            } else if (third_octet == 0) {
                domain = "X";
            } else if (third_octet == 50) {
                domain = "Y";
            } else if (third_octet == 100) {
                domain = "Z";
            } else {
                domain = "Unknown-domain";  # Fallback for any unexpected third octet values
            }

            # Print the final output line
            print user, src[user], ip[user], destination[user], domain, count[user];
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."
}

failed_attempts_to_perform_a_privileged_operation() {
    # Prompt user to enter the path to the input CSV file or skip
    read -p "Please enter the path to your failed attempt to perform a privileged operation CSV file (or type 's' to skip): " input_file

    # Allow user to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping processing of the CSV file."
        privileged_operation_successfully_performed
    fi

    # Output file
    output_file="../docs/failed_attempts_to_perform_a_privileged_operation.csv"

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Step 1: Replace all ; with , and save to a temporary file
    temp_file="temp_file.csv"
    tr ';' ',' < "$input_file" > "$temp_file"

    # Step 2: Process the temporary CSV file
    awk -F, '
    BEGIN {
        OFS=",";
        print "Username", "Source IP", "Source", "Destination IP", "Domain", "Count";
    }
    NR==1 {
        # Read the header line, skip it
        next;
    }
    {
        # Count the occurrences of each username
        count[$1]++;

        # Store the data
        src[$1]=$2;
        ip[$1]=$3;
        destination[$1]=$4;
    }
    END {
        # Print the final output
        for (user in count) {
            # Extract the third octet from the Destination IP
            split(destination[user], ip_parts, ".");
            third_octet = ip_parts[3];

            # Determine the domain based on the third octet
            if (third_octet == 1) {
                domain = "X";
            } else if (third_octet == 0) {
                domain = "Y";
            } else if (third_octet == 50) {
                domain = "Z";
            } else if (third_octet == 100) {
                domain = "A";
            } else {
                domain = "Unknown-domain";  # Fallback for any unexpected third octet values
            }

            # Print the final output line
            print user, src[user], ip[user], destination[user], domain, count[user];
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."
}

privileged_operation_successfully_performed() {
    # Prompt user to enter the path to the input CSV file or skip
    read -p "Please enter the path to your privileged operation successfully performed CSV file (or type 's' to skip): " input_file

    # Allow user to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping processing of the CSV file."
        multiple_failed_attempts_to_perform_a_privileged_operation_by_the_same_user
    fi

    # Output file
    output_file="../docs/privileged_operation_successfully_performed.csv"

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Step 1: Replace all ; with , and save to a temporary file
    temp_file="temp_file.csv"
    tr ';' ',' < "$input_file" > "$temp_file"

    # Step 2: Process the temporary CSV file
    awk -F, '
    BEGIN {
        OFS=",";
        print "Username", "Source IP", "Source", "Destination IP", "Domain", "Count";
    }
    NR==1 {
        # Read the header line, skip it
        next;
    }
    {
        # Count the occurrences of each username
        count[$1]++;

        # Store the data
        src[$1]=$2;
        ip[$1]=$3;
        destination[$1]=$4;
    }
    END {
        # Print the final output
        for (user in count) {
            # Extract the third octet from the Destination IP
            split(destination[user], ip_parts, ".");
            third_octet = ip_parts[3];

            # Determine the domain based on the third octet
            if (third_octet == 1) {
                domain = "X-1";
            } else if (third_octet == 0) {
                domain = "X";
            } else if (third_octet == 50) {
                domain = "Y";
            } else if (third_octet == 100) {
                domain = "Z";
            } else {
                domain = "Unknown-domain";  # Fallback for any unexpected third octet values
            }

            # Print the final output line
            print user, src[user], ip[user], destination[user], domain, count[user];
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."
}

multiple_failed_attempts_to_perform_a_privileged_operation_by_the_same_user() {
        # Prompt user to enter the path to the input CSV file or skip
    read -p "Please enter the path to your multiple failed attempts to perform a privileged operation by the same user CSV file (or type 's' to skip): " input_file

    # Allow user to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping processing of the CSV file."
        exit 0
    fi

    # Output file
    output_file="../docs/multiple_failed_attempt_to_perform_a_privileged_operation_by_the_same_user.csv"

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Step 1: Replace all ; with , and save to a temporary file
    temp_file="temp_file.csv"
    tr ';' ',' < "$input_file" > "$temp_file"

    # Step 2: Process the temporary CSV file
    awk -F, '
    BEGIN {
        OFS=",";
        print "Username", "Source IP", "Source", "Destination IP", "Domain", "Count";
    }
    NR==1 {
        # Read the header line, skip it
        next;
    }
    {
        # Count the occurrences of each username
        count[$1]++;

        # Store the data
        src[$1]=$2;
        ip[$1]=$3;
        destination[$1]=$4;
    }
    END {
        # Print the final output
        for (user in count) {
            # Extract the third octet from the Destination IP
            split(destination[user], ip_parts, ".");
            third_octet = ip_parts[3];

            # Determine the domain based on the third octet
            if (third_octet == 1) {
                domain = "X-1";
            } else if (third_octet == 0) {
                domain = "X";
            } else if (third_octet == 50) {
                domain = "Y";
            } else if (third_octet == 100) {
                domain = "Z";
            } else {
                domain = "Unknown-domain";  # Fallback for any unexpected third octet values
            }

            # Print the final output line
            print user, src[user], ip[user], destination[user], domain, count[user];
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."
}

privileged_operation_performed
failed_attempts_to_perform_a_privileged_operation
privileged_operation_successfully_performed
multiple_failed_attempts_to_perform_a_privileged_operation_by_the_same_user