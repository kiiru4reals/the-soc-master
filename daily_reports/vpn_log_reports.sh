#!/bin/bash
process_vpn_log_report_business_hours(){

    # Prompt the user for the input file path
    read -p "Enter the path to the input CSV file for VPN logs: " input_file

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Get the previous day's date in dd_mm_yyyy format
    previous_date=$(date -d "yesterday" +%d_%m_%Y)

    # Define the output file name with the date appended
    output_file="clean_vpn_log_report_business_hours_${previous_date}.csv"

    # Define a temporary file for intermediate data
    temp_file="temp_vpn.csv"

    # Step 1: Remove rows where xauthuser is 'N/A'
    awk -F, '$8 != "N/A"' "$input_file" > "$temp_file"

    # Step 2: Remove the 'user', 'tunnelip', and 'tunneltype' columns
    awk -F, '{OFS=","; print $1,$2,$3,$7,$8,$9,$10,$11}' "$temp_file" > "${temp_file}_2"

    # Step 3: Count occurrences of each unique xauthuser and create a new 'count' column
    awk -F, '
    NR==1 {print $0,"count"; next}
    {
        xauthuser_count[$4]++;
        data[$4] = $0
    }
    END {
        for (xauthuser in xauthuser_count) {
            print data[xauthuser],xauthuser_count[xauthuser]
        }
    }' "${temp_file}_2" > "${temp_file}_3"

    # Step 4: Sort by the 'count' column in descending order
    (head -n 1 "${temp_file}_3" && tail -n +2 "${temp_file}_3" | sort -t, -k9,9nr) > "$output_file"

    # Clean up temporary files
    rm "$temp_file" "${temp_file}_2" "${temp_file}_3"

    echo "Processed file saved as $output_file"

}

process_vpn_log_report_off_business_hours(){

    # Prompt the user for the input file path
    read -p "Enter the path to the input CSV file for VPN logs: " input_file

    # Check if the input file exists
    if [[ ! -f "$input_file" ]]; then
        echo "Input file not found!"
        exit 1
    fi

    # Get the previous day's date in dd_mm_yyyy format
    previous_date=$(date -d "yesterday" +%d_%m_%Y)

    # Define the output file name with the date appended
    output_file="../docs/clean_vpn_log_report_off_business_hours_${previous_date}.csv"

    # Define a temporary file for intermediate data
    temp_file="temp_vpn.csv"

    # Step 1: Remove rows where xauthuser is 'N/A'
    awk -F, '$8 != "N/A"' "$input_file" > "$temp_file"

    # Step 2: Remove the 'user', 'tunnelip', and 'tunneltype' columns
    awk -F, '{OFS=","; print $1,$2,$3,$7,$8,$9,$10,$11}' "$temp_file" > "${temp_file}_2"

    # Step 3: Count occurrences of each unique xauthuser and create a new 'count' column
    awk -F, '
    NR==1 {print $0,"count"; next}
    {
        xauthuser_count[$4]++;
        data[$4] = $0
    }
    END {
        for (xauthuser in xauthuser_count) {
            print data[xauthuser],xauthuser_count[xauthuser]
        }
    }' "${temp_file}_2" > "${temp_file}_3"

    # Step 4: Sort by the 'count' column in descending order
    (head -n 1 "${temp_file}_3" && tail -n +2 "${temp_file}_3" | sort -t, -k9,9nr) > "$output_file"

    # Clean up temporary files
    rm "$temp_file" "${temp_file}_2" "${temp_file}_3"

    echo "Processed file saved as $output_file"

}

process_vpn_log_report_business_hours
process_vpn_log_report_off_business_hours