#!/bin/bash
echo "I have a joke about unemployment. Too bad it won't work."

new_users_created(){
    # Step 1: Prompt user for the input CSV file
    read -p "Enter the path to your CSV file (New users created) type s to skip: " input_file

    # Step 2: Allow user to skip by typing 's' or 'S'
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping file processing."
        disabled_account
        # exit 0
    fi

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Step 3: Replace ';' with ',' in the file and create a temporary file
    temp_file="temp_cleaned.csv"
    sed 's/;/,/g' "$input_file" > "$temp_file"

    # Step 4: Process the file to count unique occurrences of the "Userdata8" column and remove duplicates
    output_file="../docs/new_users_created.csv"
    awk -F, '
    BEGIN {
        OFS=",";
        print "Src IP", "Username", "Target user", "Count"
    }
    {
        # Count occurrences of each unique combination of Src IP, Username, and Userdata8
        count[$1","$2","$3]++;
    }
    END {
        # Loop through the unique entries and print them with the count
        for (entry in count) {
            split(entry, fields, ",");
            print fields[1], fields[2], fields[3], count[entry];
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 5: Remove the temporary file
    rm "$temp_file"

    # Step 6: Inform the user
    echo "Processing complete. The output has been saved to $output_file."
}

disabled_account(){
    # Prompt the user to enter the path to the CSV file
    read -p "Enter the path to your CSV file (Disabled account) or enter 's' to skip: " input_file

    # Check if the user wants to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping processing."
        bad_password
        # exit 0
    fi

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Define the output file
    output_file="../docs/disabled_account.csv"

    # Step 1: Replace ';' with ',' and save to a temporary file
    temp_file="temp_replaced_commas.csv"
    sed 's/;/,/g' "$input_file" > "$temp_file"

    # Step 2: Process the file to count unique Username occurrences and remove duplicates
    awk -F, '
    BEGIN { OFS=","; print "Src IP","Username","Count" }
    NR>1 { count[$2]++; src[$2]=$1 }  # Count occurrences of each Username and store Src IP
    END {
        for (user in count) {
            print src[user], user, count[user]  # Print the first occurrence of each Username along with its count
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."
}

bad_password(){

    # Prompt the user for the input CSV file
    read -p "Enter the path to your CSV file (bad password) or enter 's' to skip: " input_file

    # Allow the user to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping the processing."
        # exit 0
        user_account_locked
    fi

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Temporary file to hold the modified CSV
    temp_file="temp_processed.csv"

    # Step 1: Replace ';' with ',' and save to a temporary file
    sed 's/;/,/g' "$input_file" > "$temp_file"

    # Step 2: Count occurrences of each unique Username and create the final output
    output_file="../docs/bad_password.csv"

    awk -F, '
    BEGIN {
        OFS=",";
        print "Src IP,Dst IP,Username,Count"; # Print header
    }
    {
        count[$3]++;           # Count occurrences of each Username
        src_ip[$3] = $1;      # Store the Src IP for each Username
        dst_ip[$3] = $2;      # Store the Dst IP for each Username
    }
    END {
        for (user in count) {
            print src_ip[user], dst_ip[user], user, count[user]; # Print the output
        }
    }
    ' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The final output has been saved to $output_file."

}

user_account_locked(){
    # Prompt the user for the input CSV file
    read -p "Enter the path to your CSV file (user account locked) or 's' to skip: " input_file

    # Check if the user wants to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping processing."
        user_account_unlocked
        # exit 0
    fi

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Define the output file name
    output_file="../docs/user_account_locked.csv"

    # Step 1: Replace all ';' with ',' and create a temporary file
    temp_file="temp_usernames.csv"
    sed 's/;/,/g' "$input_file" > "$temp_file"

    # Step 2: Count occurrences of usernames and generate the final output
    awk -F, '
    BEGIN { OFS=","; print "Src IP,Username,Count" }
    {
        # Count occurrences of each username
        count[$2]++;
        # Store the Src IP for the first occurrence of each username
        if (!seen[$2]++) {
            src_ip[$2] = $1;  # Store the corresponding Src IP
        }
    }
    END {
        # Print the unique usernames with their corresponding Src IP and counts
        for (user in count) {
            print src_ip[user], user, count[user];
        }
    }' "$temp_file" > "$output_file"

    # Step 3: Clean up temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."
}

user_account_unlocked(){
    # Prompt user to upload the CSV file
    read -p "Please enter the path to your CSV file (user account unlocked): " input_file

    # Check if the user wants to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping the processing."
        admin_attempted_to_reset_password
        # exit 0
    fi

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Define the output file name
    output_file="../docs/user_account_unlocked.csv"

    # Step 1: Replace ';' with ',' and create a temporary file
    temp_file="temp.csv"
    sed 's/;/,/g' "$input_file" > "$temp_file"

    # Step 2: Count unique combinations of username and userdata8 and prepare output
    awk -F, '
    {
        # Combine the username and userdata8 to create a unique key
        key = $2 "," $3;
        count[key]++;
        # Store the first occurrence for final output
        if (!(key in seen)) {
            seen[key] = $1 "," $2 "," $3;  # Store Src IP, Username, Userdata8
        }
    }
    END {
        # Print the header
        print "Src IP,username,userdata8,count";
        for (key in count) {
            print seen[key] "," count[key];
        }
    }' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."

}

admin_attempted_to_reset_password(){
    # Prompt user to upload the CSV file
    read -p "Please enter the path to your CSV file (Admin attempted to reset password) or type 's' to skip: " input_file

    # Check if the user wants to skip
    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping the processing."
        exit 0
    fi

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Define the output file name
    output_file="../docs/admin_attempted_to_reset_password.csv"

    # Step 1: Replace ';' with ',' and create a temporary file
    temp_file="temp.csv"
    sed 's/;/,/g' "$input_file" > "$temp_file"

    # Step 2: Count unique combinations of username and userdata8 and prepare output
    awk -F, '
    {
        # Combine the username and userdata8 to create a unique key
        key = $2 "," $3;
        count[key]++;
        # Store the first occurrence for final output
        if (!(key in seen)) {
            seen[key] = $1 "," $2 "," $3;  # Store Src IP, Username, Userdata8
        }
    }
    END {
        # Print the header
        print "Src IP,username,userdata8,count";
        for (key in count) {
            print seen[key] "," count[key];
        }
    }' "$temp_file" > "$output_file"

    # Step 3: Remove the temporary file
    rm "$temp_file"

    echo "Processing complete. The output has been saved to $output_file."

}

new_users_created
disabled_account
bad_password
user_account_locked
admin_attempted_to_reset_password