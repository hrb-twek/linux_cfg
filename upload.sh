cp -f ~/.bashrc _bashrc
cp -f ~/.vimrc vim/_vimrc 
cp -f ~/.gvimrc vim/lnx/_gvimrc 
# cp -f ~/.gitconfig _gitconfig
cp -f /etc/udev/rules.d/*.* ./udev_rules/
cp -f ~/bin/*.* bin/
cp -rf ~/.vim/ vim/vimfiles/
rm -rf vim/vimfiles/plugged/verilog_systemverilog.vim/.git
rm -rf vim/vimfiles/plugged/verilog_systemverilog.vim/.github
rm -rf vim/vimfiles/plugged/verilog_systemverilog.vim/test

