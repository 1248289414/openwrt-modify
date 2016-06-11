#!/bin/sh
sudo echo "Starting..."
chmod 0777 ./mksquashfs4 ./padjffs2 ./unsquashfs4
MKSQSHFS4='./mksquashfs4'
PADJFFS2='./padjffs2'
UNSQSHFS='./unsquashfs4'
case "$1" in
'extract'|'e')
offset1=`grep -oba hsqs $2 | grep -oP '[0-9]*(?=:hsqs)'`
offset2=`wc -c $2 | grep -oP '[0-9]*(?= )'`
size2=`expr $offset2 - $offset1`
#echo $offset1 " " $offset2 " " $size2
dd if=$2 of=kernel.bin bs=1 ibs=1 count=$offset1
dd if=$2 of=secondchunk.bin bs=1 ibs=1 count=$size2 skip=$offset1
sudo rm -rf squashfs-root 2>&1
sudo $UNSQSHFS -d squashfs-root secondchunk.bin
rm secondchunk.bin
;;
'create'|'c')
name=$2
[ -z $2 ] && name='new'
sudo $MKSQSHFS4 ./squashfs-root ./newsecondchunk.bin -nopad -noappend -root-owned -comp xz -Xpreset 9 -Xe -Xlc 0 -Xlp 2 -Xpb 2 -b 256k -processors 1
sudo chown $USER ./newsecondchunk.bin
cat kernel.bin newsecondchunk.bin > $name\_$(date "+%Y-%m-%d_%H%M%S").bin
$PADJFFS2 $name\_$(date "+%Y-%m-%d_%H%M%S").bin
rm newsecondchunk.bin
;;
'clean'|'C')
sudo rm -rf ./squashfs-root
sudo rm -rf ./kernel.bin
;;
*)
echo 'run
"modify.sh extract firmware.bin"
You will find file "kernel.bin" and folder "squashfs-root".
Modify "squashfs-root" as you like,after everything is done,run
"modify.sh create newfirmware.bin"
And you will get a modified firmware named newfirmware.bin.after your work,run
"modify.sh clean"
This command will delete "kernel.bin" and "squashfs-root"
'
;;
esac

