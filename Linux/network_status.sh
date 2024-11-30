#!/bin/bash

# 定义颜色
green_bg=$(tput setab 2)   # 绿色背景
red_bg=$(tput setab 1)     # 红色背景
reset=$(tput sgr0)         # 颜色重置
clear_screen=$(tput clear) # 清屏

# 定义 ping 检测目标和参数
ping_target="www.baidu.com"
ping_count=1
ping_interval=1
error_threshold=4
error_count=0

# 定义字符图案
ok_block=(
"████████    ██    ██"
"██    ██    ██  ███ "
"██    ██    █████ "
"██    ██    ██  ███"
"████████    ██    ██"
)

error_block=(
"██████    █████    ████   ██"
"██       ██   ██    ██    ██"
"██████   ███████    ██    ██"
"██       ██   ██    ██    ██ "
"██       ██   ██   ████   ██████"
)

# 用于绘制字符图案的函数
draw_block() {
    local color="$1"
    shift
    local block=("$@")
    local term_rows=$(tput lines)
    local term_cols=$(tput cols)
    local block_height=${#block[@]}
    local block_width=${#block[0]}
    local start_row=$(( (term_rows - block_height) / 2 ))
    local start_col=$(( (term_cols - block_width) / 2 ))

    # 清屏并设置背景颜色
    echo -ne "$clear_screen"
    echo -ne "$color"
    for ((i = 0; i < term_rows; i++)); do
        printf "%${term_cols}s\n" " "
    done

    # 居中显示图案
    echo -ne "${reset}"
    for ((i = 0; i < block_height; i++)); do
        tput cup $((start_row + i)) $start_col
        echo -e "${color}${block[i]}${reset}"
    done
}

# 循环检测网络状态
clear
while true; do
    if ping -c $ping_count -i $ping_interval -q $ping_target &>/dev/null; then
        error_count=0
        draw_block "$green_bg" "${ok_block[@]}"
    else
        ((error_count++))
        if [ $error_count -ge $error_threshold ]; then
            draw_block "$red_bg" "${error_block[@]}"
        fi
    fi
    sleep $ping_interval
done
