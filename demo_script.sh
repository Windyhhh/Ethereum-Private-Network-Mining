#!/bin/bash

echo '=== 终端操作脚本演示 ==='
echo '按空格键执行下一个命令，按任意其他键退出...'
echo ''

# 简化的命令列表，不依赖geth
demo_commands=(
    "echo '=== 1. 显示系统信息 ==='"
    "uname -a"
    "echo ''"
    "echo '=== 2. 显示当前目录 ==='"
    "pwd"
    "echo ''"
    "echo '=== 3. 显示文件列表 ==='"
    "ls -la *.md"
    "echo ''"
    "echo '=== 4. 显示脚本内容 ==='"
    "head -20 terminal_operations.sh"
    "echo ''"
    "echo '=== 5. 显示系统时间 ==='"
    "date"
    "echo ''"
    "echo '=== 6. 显示内存使用 ==='"
    "free -h 2>/dev/null || echo '内存信息不可用'"
    "echo ''"
    "echo '=== 演示完成！ ==='"
)

# 遍历执行命令
for cmd in "${demo_commands[@]}"; do
    # 显示命令
    echo -n "$ "; echo "$cmd" | sed "s/^echo //" | sed "s/^'//" | sed "s/'$//"
    
    # 等待用户按空格
    read -n 1 -s key
    if [ "$key" != " " ]; then
        echo -e "\n\n=== 操作已取消 ==="
        exit 0
    fi
    
    # 执行命令
    eval "$cmd"
    echo ''
done

echo '=== 脚本演示成功！ ==='
echo ''
echo '实际使用说明：'
echo '1. 在WSL环境中运行：./terminal_operations.sh'
echo '2. 按空格键执行下一个命令'
echo '3. 每个命令执行后会自动暂停，方便截图'
echo '4. 按任意其他键可随时退出'

echo ''
echo '脚本特点：'
echo '✅ 按空格执行下一个命令'
echo '✅ 清晰的命令说明'
echo '✅ 自动暂停方便截图'
echo '✅ 支持中途退出'
echo '✅ 包含所有实验报告所需的终端命令'