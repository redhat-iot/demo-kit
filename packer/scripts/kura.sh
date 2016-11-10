#!/usr/bin/env bash
set -x

mv /tmp/ifconfig /usr/sbin/ifconfig
chmod ug+x /usr/sbin/ifconfig

ln -s /usr/lib64/libudev.so.1 /usr/lib64/libudev.so.0

systemctl disable systemd-networkd
systemctl disable systemd-resolved
systemctl disable systemd-hostnamed
systemctl disable hostapd
systemctl disable wpa_supplicant
