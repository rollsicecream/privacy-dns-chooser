#!/bin/bash

echo "Welcome to the Privacy DNS chooser script for Linux version v1.3."
echo "This script will help you enable DoT with a privacy DNS provider on your Linux system."

echo "Be AWARE that the script will not run properly if the systemd-resolved package is not installed on your Linux system."
echo "Most distros nowadays do include it, but in some cases, your distribution may not come with it. Please check before running this script."
echo "To check it, do: sudo <your package manager, like apt or dnf> systemd-resolved. If it's already installed, you're good, if not, install it."

# Prompt user for DNS provider choice
echo "Choose a DNS provider:"
echo "1. Quad9 [RECOMMENDED]"
echo "2. Mullvad DNS"
echo "3. Mullvad DNS (ad, tracker, and malware blocking) [RECOMMENDED]"
echo "4. AdGuard DNS"
echo "5. NextDNS [RECOMMENDED]"

read -p "Enter the number corresponding to your choice: " choice

case $choice in
    1)
        dns_provider="9.9.9.9#dns.quad9.net"
        provider_name="Quad9 [RECOMMENDED]"
        ;;
    2)
        dns_provider="194.242.2.2#dns.mullvad.net"
        provider_name="Mullvad DNS"
        ;;
    3)
        dns_provider="194.242.2.4#base.dns.mullvad.net"
        provider_name="Mullvad DNS (ad, tracker, and malware blocking) [RECOMMENDED]"
        ;;    
    4)  
        dns_provider="94.140.14.14#dns.adguard-dns.io"
        provider_name="AdGuard DNS"
        ;;
    5)
        echo "You've selected NextDNS."
        read -p "Enter your NextDNS configuration number (e.g., a12345): " nextdns_config
        dns_provider="45.90.28.0#$nextdns_config.dns.nextdns.io"
        ipv6_provider="2a07:a8c0::#$nextdns_config.dns.nextdns.io"
        dns_provider2="45.90.30.0#$nextdns_config.dns.nextdns.io"
        ipv6_provider2="2a07:a8c1::#$nextdns_config.dns.nextdns.io"
        provider_name="NextDNS [RECOMMENDED]"
        ;;
    *)
        echo "Invalid choice. Exiting."
        echo "Your DNS provider has not been set due to errors. Put the right number : 1, 2, 3, 4 or 5."
        exit 1
        ;;
esac

# Confirm the user's choice before making changes
read -p "You've selected $provider_name. Are you sure you want to change your DNS provider? (yes/no): " confirmation

if [[ "$confirmation" != "yes" ]]; then
    echo "DNS change aborted. No changes have been made."
    exit 0
fi

resolved_conf="/etc/systemd/resolved.conf"

# Uncomment and modify DNS and DNSOverTLS settings
sudo sed -i -e "/^\[Resolve\]/,/^\s*$/ s/^#*\(DNS=\).*/\1$dns_provider/" \
            -e "/^\[Resolve\]/,/^\s*$/ s/^#*\(DNSOverTLS=\).*/\1yes/" \
            -e "/^\[Resolve\]/,/^\s*$/ s/^#*\(DNSSEC=\).*/\1yes/" \
            -e "/^\[Resolve\]/,/^\s*$/ s/^#*\(DNSSECStub=\).*/\1yes/" $resolved_conf

# Add additional DNS lines for NextDNS
if [ "$choice" -eq 5 ]; then
    echo "Adding NextDNS configuration to resolved.conf..."
    sudo tee -a $resolved_conf > /dev/null <<EOL
DNS=$ipv6_provider
DNS=$dns_provider2
DNS=$ipv6_provider2
EOL
fi

# Enable and start the systemd-resolved service
if sudo systemctl enable systemd-resolved && sudo systemctl restart systemd-resolved; then
    echo "You're all set! Your DNS has been set to $provider_name, and DNS-over-TLS has been enabled for security measures."
else
    echo "Your DNS provider has not been set due to errors. Do you have systemd-resolved installed on your system?"
fi
