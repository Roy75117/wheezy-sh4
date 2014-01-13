ref:http://askubuntu.com/questions/17823/how-to-list-all-installed-packages
sudo dpkg --clear-selections sudo dpkg --set-selections < package-list.txt sudo apt-get autoremove sudo apt-get dselect-upgrade

