#!/bin/sh

# Goes in /etc/pm/power.d/sleepiflidclosed
# From: https://bugs.launchpad.net/ubuntu/+source/xfce4-power-manager/+bug/1014891/comments/11

# If the lid is closed, then sleep when we are switched to battery mode.
case "$1" in
    true) # Going into battery mode.
        sleep 1
        grep -q closed /proc/acpi/button/lid/*/state && dbus-send --print-reply --system --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend
        ;;
    false) # Going into line power mode
        ;;
    *)
        exit
        ;;
esac
exit 0
