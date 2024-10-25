# Overview
The SOC master helps you compile reports from pre-downloaded CSV templates for some of the reports that a SOC analyst may need to compile and share with relevant stakeholders.

## Features
1. Privileged access: Compile reports for successful privileged access to have the username, source IP, destination IP,count and Source hostname.
2. Network logon: Captures all logon activities in the network (both successful and unsuccessful)
3. Privileged operations: Compile reports for successful privileged operations performed, failed privileged operations and failed privileged operations within a short time
4. Failed logon attempts on the domain controller
5. Account management: New user accounts created, bad password entries, locked accounts, unlocked accounts, disabled and deleted accounts.
6. INstalled and uninstalled applications
7. Windows successful logon sessions where there the user was already logged on but their session was locked and RDP connections made to a host which resulted to a successful login.
8. VPN connections made to your network.
9. URLs visited on the network.

## Getting Started
Installation: Install this script by cloning the repository as shown below
```sh
git clone git@github.com:kiiru4reals/the-soc-master.git
```
Create a new directory called `docs` on the root directory.
```sh
mkdir docs/
```
Navigate to the `daily_reports` directory and make all scripts executable.
```sh
cd daily_reports
sudo chmod +x *.sh
```
Run `start.sh` file
```sh
./start.sh
```

## Contribution
Contributions to this project is welcome! If you have improvements, bug fixes, or new features to suggest, please create a pull request or open an issue on the GitHub repository.