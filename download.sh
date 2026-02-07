cp -f _bashrc ~/.bashrc
cp -f vim/_vimrc ~/.vimrc
cp -f vim/lnx/_gvimrc ~/.gvimrc
# cp -f _curlrc ~/.curlrc
# cp -f _gitconfig ~/.gitconfig
sudo cp -f udev_rules/*.* /etc/udev/rules.d/

mkdir -p ~/bin
cp -f bin/*.* ~/bin/
