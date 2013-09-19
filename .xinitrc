setxkbmap -option ctrl:swapcaps     # Swap Left Control and Caps Lock

#########
# Gnome Keyring 
# https://wiki.archlinux.org/index.php/Gnome-keyring
#########
# Start a D-Bus session
source /etc/X11/xinit/xinitrc.d/30-dbus
# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start 
--components=gpg,pkcs11,secrets,ssh)
# You probably need to do this too:
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO 
SSH_AUTH_SOCK
#########

nm-applet &

exec awesome

