#!/bin/bash

echo "Welcome to the Rescue Script of the Privacy DNS Chooser Script for Linux."
read -p "Do you want to wipe the 'problematic' configuration and restore systemd-resolved to his default configuration? (yes/no): " answer

if [[ "$answer" != "yes" ]]; then
    echo "Aborting. No changes have been made."
    exit 0
fi

# Define the new content for resolved.conf
RESOLVED_CONF_CONTENT=$(cat <<EOL
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
)

# Backup the current resolved.conf
sudo cp /etc/systemd/resolved.conf /etc/systemd/resolved.conf.backup

# Overwrite the contents of resolved.conf with the new configuration
echo "$RESOLVED_CONF_CONTENT" | sudo tee /etc/systemd/resolved.conf > /dev/null

# Restart the systemd-resolved.service
sudo systemctl restart systemd-resolved

echo "resolved.conf has been reset to default configuration, and systemd-resolved.service has been restarted to make Internet working. The resolved.conf file has been rescued."
