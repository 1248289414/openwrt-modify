#!/bin/sh
name=$1
dir=$("pwd")
dir1=$dir/squashfs-root
dir2=$dir/squashfs-root/usr/lib/opkg/info
if [ -z $name ] ; then
	ls $dir/squashfs-root/usr/lib/opkg/info/ | grep .list
	echo "===================================================="
	echo "===================================================="
	echo "Select the package which would you want to delete!!!"
	echo "For example:"
	echo "$dir/rm.sh dnsmasq"
	echo "===================================================="
	echo "===================================================="
	exit 0
else
	[ ! -f $dir2/$name\.list ] && echo "Not found!" && exit 0
	sudo rm $dir2/$name\.control
	cat /home/yelanghua/OPENWRT-kitchen/squashfs-root/usr/lib/opkg/info/dnsmasq.list | while read LINE
		do
			echo $LINE
			sudo rm -r $dir1$LINE
		done
	sudo rm $dir2/$name\.list
	echo "DONE!!!"
fi
