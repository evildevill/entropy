#!/bin/bash

# This script is created by Waseem Akram ( github.com/evildevill )
# This script is an uninstallation script for entropy
# It removes the program's files and installation directories
# It is meant to be run as root

printf '\033]2;uninstall.sh\a'

G="\033[1;34m[*] \033[0m"
S="\033[1;32m[+] \033[0m"
E="\033[1;31m[-] \033[0m"

if [[ $(id -u) != 0 ]]; then
    echo -e ""$E"Permission denied!"
    exit
fi

# Define the program name and installation directories
program_name="entropy"
install_directories=("/bin/entropy" "/usr/local/bin/entropy" "/data/data/com.termux/files/usr/bin/entropy" "$HOME/entropy")

# Prompt user to confirm before proceeding with the uninstallation
echo -e ""$G"This script will remove the $program_name program and its installation directories."
read -p "Are you sure you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit
fi

# Remove the program's files and installation directories
for dir in "${install_directories}"; do
    if [[ -d $dir ]]; then
        echo -e ""$S"Removing $dir"
        rm -rf $dir
    fi
done


# #!/bin/bash

# printf '\033]2;uninstall.sh\a'

# G="\033[1;34m[*] \033[0m"
# S="\033[1;32m[+] \033[0m"
# E="\033[1;31m[-] \033[0m"

# if [[ $(id -u) != 0 ]]
# then
#    echo -e ""$E"Permission denied!"
#    exit
# fi

# {
# rm -rf ~/entropy
# rm /bin/entropy
# rm /usr/local/bin/entropy
# rm /data/data/com.termux/files/usr/bin/entropy
# } &> /dev/null