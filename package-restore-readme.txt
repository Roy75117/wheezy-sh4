ref:http://askubuntu.com/questions/17823/how-to-list-all-installed-packages
ref:https://bugs.launchpad.net/ubuntu/+source/dpkg/+bug/1232661

#backup package
dpkg --get-selections | grep -v deinstall > ~/package-list.txt

# Restore Package
sudo apt-get install dselect
sudo dselect update
sudo dpkg --clear-selections 
sudo dpkg --set-selections < package-list.txt 
sudo apt-get autoremove 
sudo apt-get dselect-upgrade


#prevent package upgrade by apt-get

#Put a package on hold
echo "package hold" | dpkg --set-selections

#Remove the hold
echo "package install" | dpkg --set-selections

#Check pachage reverse dependency
apt-cache rdepends packgae

