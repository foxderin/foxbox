sudo pacman-mirrors -i -c China -m rank
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
sudo echo -e "[archlinuxcn]\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
npm config set registry https://registry.npmmirror.com