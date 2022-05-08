<a href="https://ibb.co/82v4nFh"><img src="https://i.ibb.co/ft6GVmc/image.png" alt="image" border="0"></a>

To resolve all problems associated with installing Dnscrypt-Proxy with Entware (or similar) along with setting up various scripts to handle dnscrypt-proxy starting up including the ntp issue, this installer of dnscrypt-proxy resolves all these concerns... The only requirement is an Asus Router flashed with custom Asuswrt-Merlin Firmware.

# Requirements:
- ARM based ASUS routers that use Asuswrt-Merlin Firmware
- JFFS support and enabled

# Incompatibilities:
- No known issue

# Current features:
- [dnscrypt-proxy version 2](https://github.com/jedisct1/dnscrypt-proxy) with ODoH, DoH, and DNSCrypt version 2 protocols, multiple resolvers, and other features
- Running as nobody through nonroot binary (using --user requires change to passwd)
- Support ARM based routers
- Support OpenDNS dynamic IP update by entering your OpenDNS account information
- Handling ntp update at router boot up by starting dnscrypt-proxy with cert_ignore_timestamp option
- Redirect all DNS queries on your network to dnscrypt if user chooses to using DNS Filter Option
- Install haveged/rngd for better speed with dnscrypt and other cryptographic applications
- Support various HW RNG such as TrueRNG (tested with v3), TrueRNGpro, OneRNG, EntropyKey
- Ability to setup a swap file
- Ability to setup timezone file (/etc/localtime) used by dnscrypt-proxy and other apps
- Ability to reconfigure dnscrypt-proxy without reinstalling unlike previous installer for dnscrypt-proxy version 1.x.x
- Ability to configure anonymized relay support per Dnscrypt server through menu option or Wildcard Relay Support to cover all dnscrypt servers when automatic is selected.
- Support for NextDNS.io Account SDNS stamp as Static server.
- Support for addition of multiple static servers using SDNS Stamp and Custom Server Naming that can be mixed with servers on the resolvers list.
- Improved Installer/Update/Backup Functions.

# Changelog:
https://github.com/thuantran/dnscrypt-asuswrt-installer/commits/master

# Install/Update/Reconfig/Uninstall:
Run this command from ssh shell and following the prompt for dnscrypt-proxy version 2:
```
curl -L -s -k -O https://raw.githubusercontent.com/thuantran/dnscrypt-asuswrt-installer/master/installer && sh installer ; rm installer
```
User can safely update from dnscrypt-proxy version 1 to version 2 with above command.

If you want to use dnscrypt-proxy version 1, run this command:
```
curl -L -s -k -O https://raw.githubusercontent.com/thuantran/dnscrypt-asuswrt-installer/dnscrypt-proxy-v1/installer && sh installer dnscrypt-proxy-v1; rm installer
```

# How to check if it works
If you use OpenDNS, run this command on Windows cmd
```
nslookup -type=txt debug.opendns.com
```
You should see something like
```
"dnscrypt enabled (717473654A614970)"
```
in result.

Otherwise running this command:
```
pidof dnscrypt-proxy
```
will return a number.

# How to report issue:
I need following directory and files:
```
/jffs/dnscrypt
/jffs/scripts/dnsmasq.postconf
```
One can use this command to create a tar archive of these files:
```
echo .config > exclude-files; tar -cvf dnscrypt.tar -X exclude-files /jffs/dnscrypt /jffs/scripts/dnsmasq.postconf; rm exclude-files
```
in current directory and send me the archive for debug.

I also need following information:
- Which dns server you selected during dnscrypt installation
- Which router you're using
- Firmware and its version

# How I made this:
- Use dnscrypt-proxy binary packages from https://github.com/jedisct1/dnscrypt-proxy
- Compiling and stripping required binaries using firmware building toolchain from asuswrt-merlin
- I wrote the installer script with stuff inspired from entware-setup.sh from asuswrt-merlin
- You can look at all the stuff here https://github.com/thuantran/dnscrypt-asuswrt-installer
