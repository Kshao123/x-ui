#!/bin/bash

# 设置目标文件
install_script="install.sh"

# 检查文件是否存在
if [ ! -f "$install_script" ]; then
    echo "错误：$install_script 文件不存在"
    exit 1
fi

# 创建备份文件
backup_script="${install_script}.bak"
cp "$install_script" "$backup_script"

# 使用临时文件进行替换
temp_script=$(mktemp)
sed 's|https://raw\.githubusercontent\.com|https://ghproxy.net/https://raw.githubusercontent.com|g' "$install_script" > "$temp_script"

# 检查替换是否成功
# $? 特殊变量，表示上一个任务执行是否成功
if [ $? -eq 0 ]; then
    # 替换成功，覆盖原文件
    mv "$temp_script" "$install_script"

    # 恢复原文件权限
    chmod --reference="$backup_script" "$install_script"

    echo "成功将 $install_script 中的 GitHub 链接替换为代理链接"
    echo "原文件已备份为 $backup_script"
else
    # 替换失败
    rm "$temp_script"
    echo "替换失败，已保留原文件"
    exit 1
fi
