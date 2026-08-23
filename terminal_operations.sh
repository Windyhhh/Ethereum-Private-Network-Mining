#!/bin/bash

echo '=== 以太坊私有网络部署终端操作脚本 ==='
echo '按空格键执行下一个命令，按任意其他键退出...'
echo ''

# 环境检查
echo '=== 环境检查 ==='

# 检查是否在WSL环境中
if grep -q Microsoft /proc/version > /dev/null 2>&1; then
    echo '✅ 检测到WSL环境'
    WSL_ENV=1
else
    echo '⚠️  未检测到WSL环境，部分命令可能无法执行'
    WSL_ENV=0
fi

# 检查geth命令是否可用
geth --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo '✅ geth命令可用'
    GETH_AVAILABLE=1
else
    echo '⚠️  geth命令不可用，部分命令将跳过'
    GETH_AVAILABLE=0
fi

# 检查curl命令是否可用
curl --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo '✅ curl命令可用'
    CURL_AVAILABLE=1
else
    echo '⚠️  curl命令不可用，部分命令将跳过'
    CURL_AVAILABLE=0
fi

echo ''

# 命令列表（带条件执行标记）
declare -A commands
commands["check_geth_version"]="geth version"
commands["init_node1"]="geth --datadir /home/windy/ethereum/nodes/node1 init /home/windy/ethereum/genesis.json"
commands["list_node1_dir"]="ls -la /home/windy/ethereum/nodes/node1/geth/ 2>/dev/null || echo '节点目录不存在'"
commands["start_deploy_script"]="./deploy_eth_network.sh 2>/dev/null || echo '部署脚本执行失败'"
commands["check_geth_process"]="ps -ef | grep geth | grep -v grep 2>/dev/null || echo '没有运行的geth进程'"
commands["check_peer_count"]="curl -s -X POST -H 'Content-Type: application/json' -d '{\"jsonrpc\":\"2.0\",\"method\":\"net_peerCount\",\"params\":[],\"id\":1}' http://localhost:8545 2>/dev/null || echo '无法连接到节点'"
commands["check_block_number"]="curl -s -X POST -H 'Content-Type: application/json' -d '{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1}' http://localhost:8545 2>/dev/null || echo '无法连接到节点'"
commands["check_mining_logs"]="tail -n 10 /home/windy/ethereum/node1.log | grep -i 'mined\|sealed' 2>/dev/null || echo '挖矿日志不可用'"
commands["check_peer_status"]="geth attach http://localhost:8545 --exec 'admin.peers.length' 2>/dev/null || echo '无法连接到节点'"
commands["check_enode_info"]="geth attach http://localhost:8545 --exec 'admin.nodeInfo.enode' 2>/dev/null || echo '无法连接到节点'"

echo ''

# 定义命令执行顺序
command_sequence=(
    "echo '=== 1. 检查Geth版本 ==='"
    "check_geth_version"
    "echo ''"
    "echo '=== 2. 初始化节点1 ==='"
    "init_node1"
    "echo ''"
    "echo '=== 3. 查看节点1目录结构 ==='"
    "list_node1_dir"
    "echo ''"
    "echo '=== 4. 启动部署脚本 ==='"
    "start_deploy_script"
    "echo ''"
    "echo '=== 5. 检查节点进程 ==='"
    "check_geth_process"
    "echo ''"
    "echo '=== 6. 检查节点1连接数 ==='"
    "check_peer_count"
    "echo ''"
    "echo '=== 7. 检查区块高度 ==='"
    "check_block_number"
    "echo ''"
    "echo '=== 8. 查看节点1挖矿日志 ==='"
    "check_mining_logs"
    "echo ''"
    "echo '=== 9. 查看节点连接状态 ==='"
    "check_peer_status"
    "echo ''"
    "echo '=== 10. 查看节点enode信息 ==='"
    "check_enode_info"
    "echo ''"
    "echo '=== 终端操作完成！ ==='"
)

# 遍历执行命令
for item in "${command_sequence[@]}"; do
    # 显示命令
    echo -n "$ "; echo "$item" | sed "s/^echo //" | sed "s/^'//" | sed "s/'$//"
    
    # 等待用户按空格
    read -n 1 -s key
    if [ "$key" != " " ]; then
        echo -e "\n\n=== 操作已取消 ==="
        exit 0
    fi
    
    # 执行命令
    if [[ $item == check_* ]]; then
        # 这是一个需要条件执行的命令
        if [[ $item == check_geth_* || $item == init_node* || $item == list_node* || $item == start_deploy* || $item == check_enode* ]]; then
            # 这些命令需要geth可用
            if [ $GETH_AVAILABLE -eq 1 ]; then
                eval "${commands[$item]}"
            else
                echo "⚠️  geth命令不可用，跳过此命令"
            fi
        elif [[ $item == check_peer_count || $item == check_block_number ]]; then
            # 这些命令需要curl可用
            if [ $CURL_AVAILABLE -eq 1 ]; then
                eval "${commands[$item]}"
            else
                echo "⚠️  curl命令不可用，跳过此命令"
            fi
        else
            # 其他命令直接执行
            eval "${commands[$item]}"
        fi
    else
        # 这是一个普通echo命令
        eval "$item"
    fi
    echo ''
done

echo '=== 所有命令执行完成！ ==='
echo ''
echo '=== 脚本使用说明 ==='
echo '1. 此脚本用于辅助完成实验报告的终端命令截图'
echo '2. 按空格键执行每个命令，方便截图'
echo '3. 命令执行失败时会显示友好提示，不会终止脚本'
echo '4. 建议在WSL环境中运行以获得最佳体验'
echo '5. 脚本会自动跳过不可用的命令'
echo ''
echo '=== 实验报告截图提示 ==='
echo '请根据实验报告中的截图标记，执行相应的命令并截图'
echo '1. 截图1: 执行命令3 (查看节点1目录结构)'
echo '2. 截图8: 执行命令8 (查看节点1挖矿日志)'
echo '3. 截图9: 执行命令10 (查看节点enode信息)'
echo '4. 截图11: 执行 "cat /home/windy/ethereum/node1.log" 并截图'
echo '5. 截图12: 执行 "cat genesis.json" 并截图'