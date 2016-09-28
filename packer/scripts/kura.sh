#!/usr/bin/env bash
set -x

mv /tmp/ifconfig /usr/sbin/ifconfig
chmod ug+x /usr/sbin/ifconfig
yum -y localinstall /tmp/bluez-5.39-1.el7.x86_64.rpm
ln -s /usr/lib64/libudev.so.1 /usr/lib64/libudev.so.0
