echo "Repartitioning /dev/sdb"           
dd if=/dev/zero of=/dev/sdb bs=512 count=1
 
cat > fdisk.cmd << EOF
n
p
1
 
+32M
n
p
2
 
+7500M
n
p
3
 
 
t
1
b
t
3
82
w
EOF
 
fdisk /dev/sdb < fdisk.cmd
                          
echo "Formatting /dev/sdb"
mkdosfs         /dev/sdb1
mkfs.ext4       /dev/sdb2
  
echo "Implanting Debian System"           
[ ! -d /tmp/src ] && mkdir -p /tmp/src /tmp/mnt_system /tmp/boot
mount /dev/sdb1 /tmp/boot
mount /dev/sdb2 /tmp/mnt_system
mount /dev/sda1 /tmp/src
  
cd /tmp/src/
[ ! -f target.tgz ] && wget http://forum.cse.yzu.edu.tw/debian-sh4/download/target.tgz
 
cd /tmp
tar xfvz /tmp/src/target.tgz 
 
echo "Implanting Linux Kernel & Boot loader"
cp /tmp/mnt_system/vmlinux.ub /tmp/boot
cp /boot/uboot.sh /tmp/boot
 
echo "Add Swap space"
a=`mkswap /dev/sdb3 | tail -1`
echo $a none  swap  sw  0 0 >> /tmp/mnt_system/etc/fstab
 
echo "Umount all partitions"
umount /dev/sda1 /dev/sdb1 /dev/sdb2
 
echo "Implanted OK, please remove USB and reboot"
while true;
do
  /usr/bin/ledctl.sh blue       >/dev/null 2>&1
  sleep 1
  /usr/bin/ledctl.sh red        >/dev/null 2>&1
  sleep 1
  /usr/bin/ledctl.sh purple     >/dev/null 2>&1
  sleep 1
  /usr/bin/ledctl.sh off        >/dev/null 2>&1
  sleep 1
done
