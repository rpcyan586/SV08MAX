#!/bin/bash

# 监控的目录
MONITOR_DIR="/home/sovol/printer_data/config"

# 无限循环，监控文件变化
while true; do
    # 使用 inotifywait 监控目录变化
    # -m 选项表示持续监控
    # -e close_write 表示监控文件被写入后关闭的事件
    inotifywait -m -e close_write --format '%w%f' "${MONITOR_DIR}" | while read FILE
    do
        # sudo echo "Detected file: $(basename "$FILE")" >> /home/mount.log
        # 执行 sync 命令
        sync
    done
done

