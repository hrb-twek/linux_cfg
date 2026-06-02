#!/bin/bash
NVIM_LISTEN_ADDRESS=/tmp/vivado-nvim.pipe
# 如果服务器不存在，则新开一个终端（如konsole）启动nvim作为服务器
if [[ ! -e $NVIM_LISTEN_ADDRESS ]]; then
    exec konsole -e nvim --listen $NVIM_LISTEN_ADDRESS "$1" "+$2"
else
    # 服务器已存在，通过--server和--remote-send将新文件发送过去
    nvim --server $NVIM_LISTEN_ADDRESS --remote "$1"
    nvim --server $NVIM_LISTEN_ADDRESS --remote-send ":$2<CR>"
fi
