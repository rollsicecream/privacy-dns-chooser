# Privacy DNS Chooser Script for Linux

Welcome to the Privacy DNS Chooser Script for Linux! This script simplifies the process of enabling DNS-over-TLS with privacy-focused DNS providers on your Linux system using systemd-resolved.

## Features

- Choose from popular private DNS providers : Quad9, Mullvad DNS, and NextDNS.
- Easy setup with a very simple but user-friendly interface.
- Enhanced security and privacy with DNS-over-TLS.

## Requirements

- **systemd-resolved:** Ensure that the `systemd-resolved` package is installed on your Linux system.

## How to Use

1. Ensure systemd-resolved is installed on your Linux system.
2. Download the script from [GitHub](https://github.com/rollsicecream/privacy-dns-chooser/releases).
3. Run the script with sudo to choose your preferred DNS provider.

### DNS Providers

- **[Quad9](https://quad9.net)** : Secure and privacy-respecting DNS service.
- **[Mullvad DNS](https://mullvad.net)** : DNS service by the privacy-focused VPN provider Mullvad.
- **[NextDNS](https://nextdns.io)** : Advanced, feature-rich private and secure DNS filtering service. Enter your configuration number during setup.

## Important

This script is designed for use with systemd-resolved. Ensure it's installed before running.

## Feedback

I welcome your feedback! Report issues or share suggestions on [GitHub Issues](#https://github.com/rollsicecream/privacy-dns-chooser/issues).

## Installation

```bash
curl -O https://github.com/rollsicecream/privacy-dns-chooser/privacy_dns_chooser.sh
chmod +x privacy_dns_chooser.sh
sudo ./privacy_dns_chooser.sh
```
## Disclosure about NextDNS usage

During DNS setup, the user, if they choose NextDNS as their choice, should enter their configuration number (e.g. a12345). This configuration number will **not** and will **never** be sent to any server. This number will stay safe.

## License

This program is licensed under the GNU General Public License v3.0.









