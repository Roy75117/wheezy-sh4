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

"網樂通的 Debian 安裝方式我覺得有點怪怪的，所以花了一點時間自己寫了一個小 script 來安裝 Debian，底下介紹這個 script 該怎麼用：
"1. 請以 sh4twbox 開機，並且確定目前網樂通的網路連線是正常的，因為它待會要去元智抓 Debian 的 rootfs。
"2. 請下載此 script，再以 root 權限執行這個 script，指令是 sh build_debian.sh，執行完畢後網樂通的燈會一直換顏色，此時關機拔隨身碟再開機即可。
"3. 重開機完畢後即可以 ssh 登入網樂通，此時就是 Debian 作業系統了。
"注意事項：
"1. 這個 script 會洗掉網樂通上面的 DOM，請確定你不要裡面的資料再執行此 script。
"2. 這個 script 千萬別在 Linux 主機上執行，也許會毀掉你的系統。
"3. 安裝完畢後硬碟分割如下：
"/dev/sdb1 -> 32 MB，放 kernel 及 uboot.sh 用
"/dev/sdb2 -> 7500 MB，放 Debian 系統用
"/dev/sdb3 -> 剩下空間，作為置換記憶體用
"**** 免責聲明 ****
"以上資訊提供大家參考，請小心服用，如果出鎚，我也不敢負什麼責任說..
