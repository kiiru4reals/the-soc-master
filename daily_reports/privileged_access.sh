#!/bin/bash
privileged_access_for_business_hours(){
    # Prompt user to upload the CSV file
    read -p "Please enter the path to your CSV file (privileged access during business hours, enter s to skip): " input_file

    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Skipping privileged access for business hours."
        privileged_access_for_off_business_hours
        return
    fi

    # Replace all ; with , in the file and save to a temporary file
    tmp_file=$(mktemp)
    sed 's/;/,/g' "$input_file" > "$tmp_file"

    # Process the CSV file
    awk -F, '
    BEGIN {
        OFS=",";
        print "Username", "Count", "Source IP", "Destination IP", "Source"
    }
    NR==1 { next }
    {
        count[$1]++;
        src[$1]=$2;
        dest_ip[$1]=$3;
        source[$1]=$4;
    }
    END {
        for (user in count) {
            print user, count[user], src[user], dest_ip[user], source[user]
        }
    }
    ' "$tmp_file" > ../docs/processed_privileged_access_for_business_hours.csv

    # Clean up temporary file
    rm "$tmp_file"

    echo "Processing complete. The output has been saved to processed_privileged_access_for_business_hours.csv in the /docs directory."
}


privileged_access_for_off_business_hours(){
 # Prompt user to upload the CSV file
    read -p "Please enter the path to your CSV file (privileged access during off business hours, enter s to skip): " input_file

    if [[ "$input_file" == "s" || "$input_file" == "S" ]]; then
        echo "Going to main menu"
        ./start.sh
        return
    fi

    # Replace all ; with , in the file and save to a temporary file
    tmp_file=$(mktemp)
    sed 's/;/,/g' "$input_file" > "$tmp_file"

    # Process the CSV file
    awk -F, '
    BEGIN {
        OFS=",";
        print "Username", "Count", "Source IP", "Destination IP", "Source"
    }
    NR==1 { next }
    {
        count[$1]++;
        src[$1]=$2;
        dest_ip[$1]=$3;
        source[$1]=$4;
    }
    END {
        for (user in count) {
            print user, count[user], src[user], dest_ip[user], source[user]
        }
    }
    ' "$tmp_file" > ../docs/processed_privileged_access_for_off_business_hours.csv

    # Clean up temporary file
    rm "$tmp_file"

    echo "Processing complete. The output has been saved to processed_privileged_access_for_off_business_hours.csv in the /docs directory."
}

privileged_access_for_business_hours
privileged_access_for_off_business_hours