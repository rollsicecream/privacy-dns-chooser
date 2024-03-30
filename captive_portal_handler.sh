#!/bin/bash

# Step 1: User launches the script
echo "Welcome to the Captive Portal Handler Script."

# Step 2: Script runs and saves a backup copy of resolved.conf
cp /etc/systemd/resolved.conf /etc/systemd/resolved.conf.backup

# Step 3: Wipe and restore resolved.conf to default state
echo "Restoring resolved.conf to default state..."
sudo tee /etc/systemd/resolved.conf > /dev/null <<EOL
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it under the
#  terms of the GNU Lesser General Public License as published by the Free
#  Software Foundation; either version 2.1 of the License, or (at your option)
#  any later version.
#
# Entries in this file show the compile time defaults. Local configuration
# should be created by either modifying this file, or by creating "drop-ins" in
# the resolved.conf.d/ subdirectory. The latter is generally recommended.
# Defaults can be restored by simply deleting this file and all drop-ins.
#
# Use 'systemd-analyze cat-config systemd/resolved.conf' to display the full config.
#
# See resolved.conf(5) for details.

[Resolve]
# Some examples of DNS servers which may be used for DNS= and FallbackDNS=:
# Cloudflare: 1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
# Google:     8.8.8.8#dns.google 8.8.4.4#dns.google 2001:4860:4860::8888#dns.google 2001:4860:4860::8844#dns.google
# Quad9:      9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
#DNS=
#FallbackDNS=
#Domains=
#DNSSEC=no
#DNSOverTLS=no
#MulticastDNS=yes
#LLMNR=yes
#Cache=yes
#CacheFromLocalhost=no
#DNSStubListener=yes
#DNSStubListenerExtra=
#ReadEtcHosts=yes
#ResolveUnicastSingleLabel=no
EOL

# Restart systemd-resolved to apply changes after restoring resolved.conf
sudo systemctl restart systemd-resolved

# Step 4: Prompt the user to deal with the captive portal
echo "Please deal with the captive portal to connect to the network."

# Step 5: Detect successful connection to the network
read -p "Have you successfully connected to the network? (yes/no): " connected

# Step 6: Replace the current default state version with the backup if the user is connected
if [[ "$connected" == "yes" ]]; then
    echo "Replacing resolved.conf with the backup..."
    cp /etc/systemd/resolved.conf.backup /etc/systemd/resolved.conf
fi

# Restart systemd-resolved to apply the final changes
sudo systemctl restart systemd-resolved

# Step 7: Delete the backup file
echo "Cleaning up..."
rm /etc/systemd/resolved.conf.backup

echo "Captive portal handling complete."

