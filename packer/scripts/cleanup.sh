#!/usr/bin/env bash
set -x

# Remove traces of MAC address and UUID from network configuration
sed -E -i '/^(HWADDR|UUID)/d' /etc/sysconfig/network-scripts/ifcfg-e*

# Add net.ifnames to /etc/default/grub and rebuild grub.cfg
sed -i -e '/GRUB_CMDLINE_LINUX/ s:"$: net.ifnames=0":' /etc/default/grub
/sbin/grub2-mkconfig -o /boot/grub2/grub.cfg

# Disable udev network rules
ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules

# Lock root account
passwd -d root
passwd -l root

# Clean up yum
rpm --rebuilddb
yum -y clean all

# Remove ssh host keys
rm -rf /etc/ssh/ssh_host*_key*

# Clean up /root
rm -f /root/anaconda-ks.cfg
rm -f /root/install.log
rm -f /root/install.log.syslog
rm -rf /root/.pki

# Clean up /var/log
>/var/log/cron
>/var/log/dmesg
>/var/log/lastlog
>/var/log/maillog
>/var/log/messages
>/var/log/secure
>/var/log/wtmp
>/var/log/audit/audit.log
>/var/log/rhsm/rhsm.log
>/var/log/rhsm/rhsmcertd.log
rm -f /var/log/*.old
rm -f /var/log/*.log
rm -f /var/log/*.syslog

# Clean /tmp
rm -rf /tmp/*
rm -rf /tmp/*.*

# Fixes these issues with network startup on CentOS, Fedora, and RHEL
# https://github.com/CentOS/sig-cloud-instance-build/issues/24
# https://github.com/CentOS/sig-cloud-instance-build/issues/38
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
PERSISTENT_DHCLIENT="yes"
EOF

echo '==> Clear out swap and disable until reboot'
DISK_USAGE_BEFORE_CLEANUP=$(df -h)
set +e
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
	2|0) ;;
	*) exit 1 ;;
esac
set -e
if [ "x${swapuuid}" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    swappart=$(readlink -f /dev/disk/by-uuid/$swapuuid)
    /sbin/swapoff "${swappart}"
    dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

echo "==> Zeroing out empty area to save space in the final image"
# Zero out the free space to save space in the final image.  Contiguous
# zeroed space compresses down to nothing.
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync

echo "==> Disk usage before cleanup"
echo ${DISK_USAGE_BEFORE_CLEANUP}

echo "==> Disk usage after cleanup"
df -h

# Clear history
history -c
