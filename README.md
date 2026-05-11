<p align="center">
  <a href="https://ibb.co/82v4nFh"><img src="https://i.ibb.co/ft6GVmc/image.png" alt="Asuswrt-Merlin Dnscrypt-Proxy Installer" border="0"></a>
</p>

# Asuswrt-Merlin Dnscrypt-Proxy Installer

Install, update, reconfigure, and remove [dnscrypt-proxy v2](https://github.com/jedisct1/dnscrypt-proxy) on supported ASUS routers running Asuswrt-Merlin firmware. The installer handles the router-specific setup work that is usually required when installing through Entware or similar package managers, including startup scripts and the boot-time NTP timestamp issue.

## Requirements

- ASUS router running custom [Asuswrt-Merlin](https://www.asuswrt-merlin.net/) firmware.
- ARMv7 or ARMv8/aarch64 router architecture.
- Router operating in router mode.
- JFFS custom scripts and configs enabled. If they are disabled, the installer attempts to enable them automatically.
- Firmware version `384.11` or newer for `service` command support.
- SSH access to the router.

## Incompatibilities

- No known issues.

## Features

- Installs [dnscrypt-proxy v2](https://github.com/jedisct1/dnscrypt-proxy) with support for ODoH, DoH, DNSCrypt v2, multiple resolvers, and other dnscrypt-proxy features.
- Runs dnscrypt-proxy as `nobody` through the bundled `nonroot` helper.
- Supports ARMv7 and ARMv8/aarch64 ASUS routers.
- Supports OpenDNS dynamic IP updates by storing your OpenDNS account information during setup.
- Starts dnscrypt-proxy with `cert_ignore_timestamp` at boot to work around NTP timestamp availability during router startup.
- Optionally redirects LAN DNS queries to dnscrypt-proxy through the ASUS DNS Filter option.
- Optionally installs `haveged` or `rngd` to improve entropy availability for dnscrypt-proxy and other cryptographic applications.
- Supports hardware random number generators including TrueRNG, TrueRNGpro, OneRNG, and EntropyKey.
- Can create a swap file.
- Can configure `/etc/localtime` for dnscrypt-proxy and other router applications.
- Allows dnscrypt-proxy reconfiguration without a full reinstall.
- Supports anonymized DNSCrypt relay configuration through menu options, including wildcard relay support for compatible DNSCrypt servers.
- Supports NextDNS account SDNS stamps as static servers.
- Supports multiple static servers using SDNS stamps and custom server names that can be mixed with resolver-list servers.
- Includes installer, update, backup, reconfiguration, and uninstall workflows.

## Install, update, reconfigure, or uninstall

SSH into your router and run:

```sh
curl -L -s -k -O https://raw.githubusercontent.com/thuantran/dnscrypt-asuswrt-installer/master/installer && sh installer; rm installer
```

Follow the interactive prompts. You can safely use the same command to update from dnscrypt-proxy v1 to v2.

### Legacy dnscrypt-proxy v1

If you specifically need the legacy dnscrypt-proxy v1 installer, run:

```sh
curl -L -s -k -O https://raw.githubusercontent.com/thuantran/dnscrypt-asuswrt-installer/dnscrypt-proxy-v1/installer && sh installer dnscrypt-proxy-v1; rm installer
```

## Managing dnscrypt-proxy

Recommended service commands:

```sh
service {start|stop|restart|kill}_dnscrypt-proxy
```

The manager script also supports equivalent commands:

```sh
/jffs/dnscrypt/manager {start|stop|restart|kill}
```

## Verify that dnscrypt-proxy is running

Check for a running dnscrypt-proxy process:

```sh
pidof dnscrypt-proxy
```

A numeric process ID means dnscrypt-proxy is running.

If you use OpenDNS, you can also run this from a Windows Command Prompt:

```cmd
nslookup -type=txt debug.opendns.com
```

A successful OpenDNS result includes text similar to:

```text
"dnscrypt enabled (717473654A614970)"
```

## Troubleshooting and issue reports

When reporting an issue, include the following directory and files:

```text
/jffs/dnscrypt
/jffs/scripts/init-start
/jffs/scripts/dnsmasq.postconf
/jffs/scripts/services-stop
/jffs/scripts/service-event-end
```

You can create a debug archive from the router shell with:

```sh
echo .config > exclude-files; tar -cvf dnscrypt.tar -X exclude-files /jffs/dnscrypt /jffs/scripts/init-start /jffs/scripts/dnsmasq.postconf /jffs/scripts/services-stop /jffs/scripts/service-event-end; rm exclude-files
```

Send `dnscrypt.tar` with your issue report and include:

- The DNS server selected during dnscrypt-proxy installation.
- Router model.
- Firmware name and version.
- Any relevant error output from the installer or manager script.

## Changelog

See the [commit history](https://github.com/thuantran/dnscrypt-asuswrt-installer/commits/master) for changes.

## Development checks

Repository shell scripts are written for POSIX/BusyBox `ash` compatibility. Avoid Bash-only syntax such as arrays, process substitution, `[[ ... ]]`, and non-portable `pipefail`.

Run the repository quality helper before opening a pull request:

```sh
tools/code-quality.sh
```

The helper validates installer artifact `.md5sum` files, runs ShellCheck on detected shell scripts, and checks formatting with `shfmt`.

To apply `shfmt` formatting locally, run:

```sh
tools/code-quality.sh --fix
```

If CI reports `shfmt` formatting differences, you can also run the `Create shfmt formatting PR` workflow against the affected branch to open an automated formatting pull request.

Pull requests that change shell scripts, checksum files, tools, prompts, or workflows are also reviewed by the Codex Code Improvement workflow when the repository has an `OPENAI_API_KEY` Actions secret configured. The Codex prompt includes the local code-quality output so formatting failures can be reported with the same remediation steps shown in CI.

## Project notes

- Dnscrypt-Proxy binaries come from [jedisct1/dnscrypt-proxy](https://github.com/jedisct1/dnscrypt-proxy).
- Required helper binaries are compiled and stripped with the Asuswrt-Merlin firmware build toolchain.
- The installer script was inspired by `entware-setup.sh` from Asuswrt-Merlin.
- Project source is available in this repository: <https://github.com/thuantran/dnscrypt-asuswrt-installer>.
- License:[GPL-3.0 License](https://raw.githubusercontent.com/thuantran/dnscrypt-asuswrt-installer/master/LICENSE)

## Donate

This project is open source and free to use under the GPL-3.0 license. If you want to support future development, you can donate through:
- [PayPal](https://paypal.me/swotrb)
- [Buy Me a Coffee](https://www.buymeacoffee.com/swotrb)
