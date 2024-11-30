#!/bin/bash

# 检查是否以root用户运行
if [[ $EUID -ne 0 ]]; then
    echo "请使用sudo或root权限运行此脚本！"
    exit 1
fi

# 检查是否安装 dialog
if ! command -v dialog &>/dev/null; then
    echo "正在安装 dialog..."
    sudo pacman -S --noconfirm dialog
fi

# 选单函数
menu() {
    temp_file=$(mktemp /tmp/arch_linux_optimization_XXXXXX.txt)

    dialog --clear \
        --backtitle "Arch Linux 优化脚本" \
        --title "选择操作" \
        --menu "请选择需要执行的操作：" 20 60 13 \
        1 "配置 pacman 镜像源" \
        2 "启用 archlinuxcn 仓库" \
        3 "配置 Flatpak 镜像源" \
        4 "配置 NPM 镜像源" \
        5 "优化 yay 镜像" \
        6 "安装常用工具 (git, wget等)" \
        7 "清理系统垃圾" \
        8 "安装开发环境 (Python, Node.js等)" \
        9 "配置性能优化 (Swap, I/O等)" \
        10 "检查系统更新" \
        11 "查看系统信息" \
        12 "退出" \
        13 "安装 AUR 管理器 (yay)" 2>$temp_file

    choice=$(<"$temp_file")
    rm -f "$temp_file"
    case $choice in
    1) configure_pacman_mirrors ;;
    2) enable_archlinuxcn ;;
    3) configure_flatpak ;;
    4) configure_npm ;;
    5) optimize_yay ;;
    6) install_common_tools ;;
    7) clean_system ;;
    8) install_dev_env ;;
    9) configure_performance ;;
    10) check_system_updates ;;
    11) show_system_info ;;
    12) exit 0 ;;
    13) install_aur_helper ;;
    *) dialog --msgbox "无效选项，请重试。" 10 30 ;;
    esac
}

# 配置 pacman 镜像源
configure_pacman_mirrors() {
    sudo pacman-mirrors -i -c China -m rank
    dialog --msgbox "pacman 镜像源已配置完成！" 10 30
}

# 启用 archlinuxcn 仓库
enable_archlinuxcn() {
    if ! grep -q "\[archlinuxcn\]" /etc/pacman.conf; then
        echo -e "\n[archlinuxcn]\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" | sudo tee -a /etc/pacman.conf
        sudo pacman -Sy --noconfirm archlinuxcn-keyring
    fi
    dialog --msgbox "archlinuxcn 仓库已启用！" 10 30
}

# 配置 Flatpak 镜像源
configure_flatpak() {
    sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
    dialog --msgbox "Flatpak 镜像源已配置完成！" 10 30
}

# 配置 NPM 镜像源
configure_npm() {
    npm config set registry https://registry.npmmirror.com
    dialog --msgbox "NPM 镜像源已配置完成！" 10 30
}

# 优化 yay 镜像
optimize_yay() {
    if command -v yay &>/dev/null; then
        yay --editrepo --save --aururl https://aur.tuna.tsinghua.edu.cn
        dialog --msgbox "yay 镜像源已优化！" 10 30
    else
        dialog --msgbox "未检测到 yay，跳过操作。" 10 30
    fi
}

# 安装常用工具
install_common_tools() {
    sudo pacman -S --noconfirm git wget curl vim
    dialog --msgbox "常用工具已安装完成！" 10 30
}

# 清理系统垃圾
clean_system() {
    sudo pacman -Rns $(pacman -Qdtq) --noconfirm
    sudo pacman -Scc --noconfirm
    dialog --msgbox "系统垃圾已清理！" 10 30
}

# 安装开发环境 (Python, Node.js等)
install_dev_env() {
    sudo pacman -S --noconfirm python python-pip nodejs npm
    dialog --msgbox "开发环境已安装！" 10 30
}

# 配置性能优化 (Swap, I/O等)
configure_performance() {
    sudo systemctl enable --now zswap
    dialog --msgbox "性能优化已启用！" 10 30
}

# 检查系统更新
check_system_updates() {
    sudo pacman -Syu --noconfirm
    dialog --msgbox "系统更新已完成！" 10 30
}

# 查看系统信息
show_system_info() {
    temp_file=$(mktemp /tmp/system_info_XXXXXX.txt)

    {
        echo "操作系统信息："
        hostnamectl
        echo
        echo "内存使用情况："
        free -h
        echo
        echo "磁盘使用情况："
        df -h --total
        echo
        echo "当前用户和登录会话："
        who
        echo
        echo "内核日志（最近5条）："
        journalctl -n 5 --no-pager
    } > "$temp_file"

    dialog --textbox "$temp_file" 20 80
    rm -f "$temp_file"
}

# 安装 AUR 管理器
install_aur_helper() {
    if command -v yay &>/dev/null; then
        dialog --msgbox "yay 已安装，无需重复安装。" 10 30
    else
        dialog --infobox "正在安装 AUR 管理器 yay..." 10 30
        sudo pacman -S --needed --noconfirm base-devel git
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay || { dialog --msgbox "克隆 yay 仓库失败！" 10 30; return; }
        makepkg -si --noconfirm
        cd - || return
        rm -rf /tmp/yay
        dialog --msgbox "yay 已成功安装！" 10 30
    fi
}

# 主循环
while true; do
    menu
done
