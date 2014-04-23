#!/bin/sh

cat > /etc/proftpd.conf <<EOF
DefaultRoot                     /media/ext/public/

Include /etc/proftpd/modules.conf
UseIPv6				on
IdentLookups			off

ServerName			"simpl"
ServerType			standalone
DeferWelcome			off

MultilineRFC2228		on
DefaultServer			on
ShowSymlinks			on

TimeoutNoTransfer		600
TimeoutStalled			600
TimeoutIdle			1200

DisplayLogin                    welcome.msg
DisplayChdir               	.message true
ListOptions                	"-l"

DenyFilter			\*.*/

Port				8822

MaxInstances			30

User				proftpd
Group				nogroup

Umask				022  022
AllowOverwrite			on

AuthOrder mod_auth_file.c
AuthUserFile /etc/proftpd/passwd
AuthGroupFile /etc/proftpd/groups
RequireValidShell off

SFTPEngine on
SFTPHostKey /etc/ssh/ssh_host_rsa_key
SFTPAuthMethods publickey
SFTPAuthorizedUserKeys file:/etc/proftpd/authorized_keys

TransferLog /var/log/proftpd/xferlog
SystemLog   /var/log/proftpd/proftpd.log
EOF

cat > /etc/proftpd/modules.conf <<EOF
ModulePath /usr/lib/proftpd

ModuleControlsACLs insmod,rmmod allow user root
ModuleControlsACLs lsmod allow user *

LoadModule mod_ctrls_admin.c
LoadModule mod_sftp.c
LoadModule mod_unique_id.c
LoadModule mod_copy.c
LoadModule mod_deflate.c
LoadModule mod_ifversion.c
# keep this module the last one
LoadModule mod_ifsession.c
EOF

echo "ftp:x:1900:65534::/srv/ftp:/bin/false" > /etc/proftpd/passwd
echo "nogroup:x:65534:" > /etc/proftpd/group
