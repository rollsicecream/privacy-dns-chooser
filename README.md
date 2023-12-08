## Work in progress!

# Privacy DNS chooser.

Welcome to the Privacy DNS chooser script. This script allows you to use Cloudlflare, Quad9, NextDNS and Mullvad DNS on Linux with systemd-resolved. It also enables recommended configs like DoT (DNS-over-TLS, as DoH isn't avaliable on systemd-resolved, yet...). This script is only avaliable on Linux.

## Why a script?

I wanted to create this script because many people very new to Linux and discovered great tools like NextDNS may not feel comfortable going to a terminal and edit the resolved.conf file of their Linux distribution. If they do a change, by mistake, it could just break the network of their device.

## Can we just do the same thing with a GUI?

Well, as far as I know, no... in GNOME or KDE, the default assistant to manage your internet connections (nm-connection-editor) only supports using IP addresses as DNS providers. I don't recommend using DNS providers that only uses IP addresses to deliver their DNS services because these are unencrypted.

## Why a script?

I wanted to create this script because many people very new to Linux and discovered great tools like NextDNS may not feel comfortable going to a terminal and edit the resolved.conf file of their Linux distribution. If they do a change, by mistake, it could just break the network of their device.

## Disclosure about NextDNS usage on the script.

On the script, if you choose NextDNS, it will ask you if you want to use the default NextDNS config or your own configuration (e.g. a12345.dns.nextdns.io). Your configuration number will never be sent to any server.
