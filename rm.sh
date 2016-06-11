#!/bin/sh
dir=$("pwd")
dir1=$dir/squashfs-root
dir2=$dir/squashfs-root/usr/lib/opkg/info
dir3=$dir/squashfs-root/usr/lib/opkg/status
if [ -z $1 ] ; then
	ls $dir2 | grep .list
	echo "===================================================="
	echo "===================================================="
	echo "Select the package which would you want to delete!!!"
	echo "For example:"
	echo "$dir/rm.sh dnsmasq"
	echo "===================================================="
	echo "===================================================="
	exit 0
fi
for name in $@
	do
		[ ! -f $dir2/$name\.list ] && echo "Not found $name!!!" && continue
		cat $dir2/$name\.list | while read LINE
			do
				echo $LINE
				sudo rm -rf $dir1$LINE
			done
		[ -f $dir2/$name\.conffiles ] && cat $dir2/$name\.conffiles | while read LINE
			do
				echo $LINE
				sudo rm -rf $dir1$LINE
			done
		sudo sed -i "/Package: $name/,/^$/d" $dir3
		sudo rm -rf $dir2/$name\.conffiles
		sudo rm -rf $dir2/$name\.list
		sudo rm -rf $dir2/$name\.control
		sudo rm -rf $dir2/$name\.prerm
		echo "DONE!!!"
done
