#!/bin/bash

echo '=== 测试终端操作脚本 ==='
echo ''

# 1. 测试脚本权限
echo '1. 测试脚本权限...'
chmod +x terminal_operations.sh
if [ $? -eq 0 ]; then
    echo '✅ 脚本权限设置成功'
else
    echo '❌ 脚本权限设置失败'
fi
echo ''

# 2. 测试脚本结构
echo '2. 测试脚本结构...'
if [ -f terminal_operations.sh ]; then
    echo '✅ 脚本文件存在'
    
    # 检查脚本行数
    lines=$(wc -l < terminal_operations.sh)
    echo "   脚本行数: $lines"
    
    # 检查命令列表
    commands_count=$(grep -c '"echo ' terminal_operations.sh)
    echo "   命令数量: $commands_count"
    
    # 显示部分命令
    echo '   前5个命令:'
    grep '"echo ' terminal_operations.sh | head -5
    
else
    echo '❌ 脚本文件不存在'
fi
echo ''

# 3. 测试主要命令是否可用
echo '3. 测试主要命令是否可用...'

# 测试geth命令
geth --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo '✅ geth命令可用'
    geth --version | head -1
else
    echo '❌ geth命令不可用'
fi

# 测试curl命令
curl --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo '✅ curl命令可用'
else
    echo '❌ curl命令不可用'
fi

echo ''
echo '=== 测试完成！ ==='
echo '您可以使用以下命令运行终端操作脚本:'
echo '  ./terminal_operations.sh'
echo '按空格键执行下一个命令，按任意其他键退出'