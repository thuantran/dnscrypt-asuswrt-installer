So to solve all the problems with installing dnscrypt with entware (or similar) then setting up various scripts to handle dnscrypt-proxy starting up including the ntp issue, I made my own installer for dnscrypt-proxy.

# Requirements:
- ARM or MIPSEL based ASUS routers
- asuswrt-merlin firmwares or compatible
- jffs support and script enabled

# Incompatibilities:
- No known issue

# Current features:
- dnscrypt-proxy version 2 with DoH and DNSCrypt version 2 protocol, multiple resolvers, and other features
- Running as nobody through nonroot binary (using --user requires change to passwd)
- Support ARM and MIPSEL based routers
- Support OpenDNS dynamic IP update by entering your OpenDNS account information
- Handling ntp update at router boot up by starting dnscrypt-proxy with cert_ignore_timestamp option
- Redirect all DNS queries on your network to dnscrypt if user chooses to
- Install haveged/rngd for better speed with dnscrypt and other cryptographic applications
- Support various HW RNG such as TrueRNG (tested with v3), TrueRNGpro, OneRNG, EntropyKey
- Ability to setup a swap file
- Ability to setup timezone file (/etc/localtime) used by dnscrypt-proxy and other apps
- Ability to reconfigure dnscrypt-proxy without reinstalling unlike previous installer for dnscrypt-proxy version 1.x.x

# Changelog:
https://github.com/thuantran/dnscrypt-asuswrt-installer/commits/master

# Installation:
Run this command from ssh shell and following the prompt for dnscrypt-proxy version 2:
```
curl -L -s -k -O https://raw.githubusercontent.com/thuantran/dnscrypt-asuswrt-installer/master/installer && sh installer ; rm installer
```
For dnscrypt-proxy version 1 use:
```
curl -L -s -k -O https://raw.githubusercontent.com/thuantran/dnscrypt-asuswrt-installer/dnscrypt-proxy-v1/installer && sh installer dnscrypt-proxy-v1; rm installer
```
# Update/Reconfig:
Just run the installation script above again

# Uninstall:
Just remove /jffs/dnscrypt directory and restart your router

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
/jffs/scripts/firewall-start
/jffs/scripts/wan-start
```
One can use this command to create a tar archive of these files:
```
echo .config > exclude-files; tar -cvf dnscrypt.tar -X exclude-files /jffs/dnscrypt /jffs/scripts/dnsmasq.postconf /jffs/scripts/firewall-start /jffs/scripts/wan-start ; rm exclude-files
```
in current directory and send me the archive for debug.

I also need follwoing information:
- Which dns server you selected during dnscrypt installtion
- Which router you're using
- Firmware and its version

# How I made this:
- Compiling and stripping dnscrypt-proxy and nonroot using firmware building toolchain from asuswrt-merlin
- Write the installer script with stuffs inspired from entware-setup.sh from asuswrt-merlin
- You can look at all the stuffs here https://github.com/thuantran/dnscrypt-asuswrt-installer
