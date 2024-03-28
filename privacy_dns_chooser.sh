#!/bin/bash

# Variables declaration
RED='\033[0;31m' # red color
NC='\033[0m' # no color to terminate red start
resolved_conf="/etc/systemd/resolved.conf" # path to systemd-resolved configuration file

# Checking if user is root
if [ $EUID != 0 ]; then
	printf "Make sure you're running this script as ${RED}ROOT${NC}\n"
	exit 1
fi

printf "Welcome to the Privacy DNS chooser script for Linux version v1.2.\n"
printf "This script will help you enable ${RED}DoT${NC} with a privacy ${RED}DNS${NC} provider on your Linux system.\n"
printf "Be ${RED}AWARE${NC} that the script will not run properly if the ${RED}systemd-resolved${NC} package is not installed on your Linux system.\n"
printf "Most distros nowadays do include it, but in some cases, your distribution may not come with it. Please ${RED}check${NC} before running this script.\n"
printf "To check it, do: ${RED}sudo${NC} <your package manager, like ${RED}apt${NC} or ${RED}dnf${NC}> systemd-resolved. If it's already installed, you're good, if not, install it.\n"

# Prompt user for DNS provider choice
printf "Choose a DNS provider:\n"
printf "1. ${RED}Quad9${NC} [RECOMMENDED]\n"
printf "2. ${RED}Mullvad DNS${NC}\n"
printf "3. ${RED}Mullvad DNS${NC} (ad, tracker, and malware blocking) [RECOMMENDED]\n"
printf "4. ${RED}AdGuard DNS${NC}\n"
printf "5. ${RED}NextDNS${NC} [RECOMMENDED]\n"

printf "Enter the number corresponding to your choice: "; read choice

case $choice in
    1)
        dns_provider="9.9.9.9#dns.quad9.net"
        provider_name="${RED}Quad9${NC} [RECOMMENDED]"
        ;;
    2)
        dns_provider="194.242.2.2#dns.mullvad.net"
        provider_name="${RED}Mullvad DNS${NC}"
        ;;
    3)
        dns_provider="194.242.2.4#base.dns.mullvad.net"
        provider_name="${RED}Mullvad DNS (ad, tracker, and malware blocking)${NC} [RECOMMENDED]"
        ;;    
    4)  
        dns_provider="94.140.14.14#dns.adguard-dns.io"
        provider_name="${RED}AdGuard DNS${NC}"
        ;;
    5)
        printf "You've selected ${RED}NextDNS${NC}.\n"
        provider_name="${RED}NextDNS${NC} [RECOMMENDED]"
        printf "Enter your $provider_name configuration number (e.g., a12345): "; read nextdns_config
        dns_provider="45.90.28.0#$nextdns_config.dns.nextdns.io"
        ipv6_provider="2a07:a8c0::#$nextdns_config.dns.nextdns.io"
        dns_provider2="45.90.30.0#$nextdns_config.dns.nextdns.io"
        ipv6_provider2="2a07:a8c1::#$nextdns_config.dns.nextdns.io"
        ;;
    *)
        printf "Invalid choice. Exiting.\n"
        printf "Your ${RED}DNS${NC} provider has not been set due to errors. Put the right number: 1, 2, 3, 4 or 5."
        exit 1
        ;;
esac

# Confirm the user's choice before making changes
printf "You've selected $provider_name.\nAre you sure you want to change your ${RED}DNS${NC} provider? (yes/no): "; read confirmation

if [[ "$confirmation" != "yes"  ]] && [[ "$confirmation" != "y"  ]]; then
    printf "${RED}DNS{$NC} change aborted. No changes have been made.\n"
    exit 0
fi

# Uncomment and modify DNS and DNSOverTLS settings
sed -i -e "/^\[Resolve\]/,/^\s*$/ s/^#*\(DNS=\).*/\1$dns_provider/" \
            -e "/^\[Resolve\]/,/^\s*$/ s/^#*\(DNSOverTLS=\).*/\1yes/" \
            -e "/^\[Resolve\]/,/^\s*$/ s/^#*\(DNSSEC=\).*/\1yes/" \
            -e "/^\[Resolve\]/,/^\s*$/ s/^#*\(DNSSECStub=\).*/\1yes/" $resolved_conf

# Add additional DNS lines for NextDNS
if [ "$choice" -eq 5 ]; then
    printf "Adding NextDNS configuration to resolved.conf...\n"
    tee -a $resolved_conf > /dev/null <<EOL
DNS=$ipv6_provider
DNS=$dns_provider2
DNS=$ipv6_provider2
EOL
fi

# Enable and start the systemd-resolved service
if systemctl enable systemd-resolved && systemctl restart systemd-resolved; then
    printf "You're all set! Your ${RED}DNS${NC} has been set to $provider_name, and ${RED}DNS-over-TLS${NC} has been enabled for security measures."
else
    printf "Your ${RED}DNS${NC} provider has not been set due to errors. Do you have ${RED}systemd-resolved${NC} installed on your system?"
fi
