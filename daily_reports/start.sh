#!/bin/bash

run_script() {
    script_path="$1"
    if [[ ! -x "$script_path" ]]; then
        echo "$script_path is not executable. Making it executable..."
        chmod +x "$script_path"
    fi
    echo "Running $script_path..."
    "$script_path"
}

while true; do
    echo "Select an option to run: (Each script has a really bad (should I say dark?) joke, pardon my sense of humor)" 
    echo "1) Privileged access: Users who ran special operations successfully. (business and non-business hours)"
    echo "2) Network logon (business and non-business hours)"
    echo "3) Privileged operations report: Failed privileged operations "
    echo "4) Failed logon attempts made to the domain controller"
    echo "5) Account management"
    echo "6) Installed and uninstalled applications"
    echo "7) Windows successful logon: Unlock and RDP sessions"
    echo "8) VPN connection (Business and non-business hours)"
    echo "9) URLs visited" 
    echo "10) Exit"
    read -p "Enter a number (1-10): " choice

    case $choice in
        1)
            echo "Preparing access for Special privileges assigned for new logon. (Today, I asked Google Assistant why I am still single and it opened the front camera.)"
            ./privileged_access.sh
            ;;
        2)
            echo "Running network logon report. (My math teacher died, guess who is sleeping when I am talking)"
            ./net_logon_report.sh
            ;;
        3)
            echo "Running privileged operations. (Do you know how we say 'one man's trash is another man's treasure?' that's how I discovered that I was adopted.)"
            ./privileged_operations.sh
            ;;
        4)
            echo "Failed logon (Domain Controller). A bad joke -> My girlfriend left me a note on my PS 5 telling me that 'This isn't working' guess who's been gaming for the last three hours?"
            ./failed_logon_domain_controller.sh
            ;;
        5)
            echo "Starting Account management. When does a joke become a dad joke? When it leaves and it never comes back"
            ./account_management_report.sh
            ;;
        6)
            echo "Installed and uninstalled applications. You aren't completely useless, you can always be used as a bad example"
            ./installed_uninstalled_applications.sh
            ;;
        7)
            echo "Windows successful logon: Unlock and RDP sessions. I made a website for orphans, unfortunately it doesn't have a homepage"
            ./windows_successful_logon_unlock_rdp_sessions.sh
            ;;
        8)
            echo "VPN connections. Dark humor is like food. Africans do not get it."
            ./vpn_log_reports.sh
            ;;
        9)
            echo "URLs visited. Cremation is my last hope for a really hot body"
            ./urls_visited_in_the_network.sh 
            ;;
        10)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
