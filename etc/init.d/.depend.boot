TARGETS = mountkernfs.sh hostname.sh udev mountdevsubfs.sh hwclock.sh networking mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh urandom checkroot.sh bootmisc.sh checkroot-bootclean.sh kmod checkfs.sh udev-mtab mtab.sh procps
INTERACTIVE = udev checkroot.sh checkfs.sh
udev: mountkernfs.sh
mountdevsubfs.sh: mountkernfs.sh udev
hwclock.sh: mountdevsubfs.sh
networking: mountkernfs.sh mountall.sh mountall-bootclean.sh urandom
mountall.sh: checkfs.sh checkroot-bootclean.sh
mountall-bootclean.sh: mountall.sh
mountnfs.sh: mountall.sh mountall-bootclean.sh networking
mountnfs-bootclean.sh: mountall.sh mountall-bootclean.sh mountnfs.sh
urandom: mountall.sh mountall-bootclean.sh hwclock.sh
checkroot.sh: hwclock.sh mountdevsubfs.sh hostname.sh
bootmisc.sh: mountall-bootclean.sh checkroot-bootclean.sh mountnfs-bootclean.sh mountall.sh mountnfs.sh udev
checkroot-bootclean.sh: checkroot.sh
kmod: checkroot.sh
checkfs.sh: checkroot.sh mtab.sh
udev-mtab: udev mountall.sh mountall-bootclean.sh
mtab.sh: checkroot.sh
procps: mountkernfs.sh mountall.sh mountall-bootclean.sh udev
