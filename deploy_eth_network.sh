#!/bin/bash

# 部署以太坊私有网络脚本
set -e

echo "=== 以太坊私有网络部署开始 ==="

# 1. 准备工作
Ethereum_DIR="/home/windy/ethereum"
GENESIS_FILE="$Ethereum_DIR/genesis.json"

# 清理旧的节点数据
pkill -f geth || true
sleep 3
rm -rf "$Ethereum_DIR/nodes" || true
mkdir -p "$Ethereum_DIR/nodes/node{1..4}"

# 2. 初始化所有节点
echo "=== 初始化所有节点 ==="
for i in {1..4}; do
    echo "初始化节点 $i..."
    geth --datadir "$Ethereum_DIR/nodes/node$i" init "$GENESIS_FILE"
done

# 3. 启动节点1并获取enode地址
echo "=== 启动节点1 ==="
nohup geth --datadir "$Ethereum_DIR/nodes/node1" \
    --networkid 666 \
    --identity "node1" \
    --port 30303 \
    --http \
    --http.addr "0.0.0.0" \
    --http.port 8545 \
    --http.corsdomain "*" \
    --http.api "admin,debug,web3,eth,txpool,personal,ethash,miner,net" \
    --nodiscover \
    --ipcdisable \
    --authrpc.port 8551 \
    --verbosity 3 > "$Ethereum_DIR/node1.log" 2>&1 &

echo "等待节点1启动..."
sleep 15

# 4. 获取节点1的enode地址
ENODE=$(grep -o "enode://[^@]*@127.0.0.1:30303?discport=0" "$Ethereum_DIR/node1.log" || echo "")
if [ -z "$ENODE" ]; then
    echo "❌ 无法获取节点1的enode地址"
    tail -n 30 "$Ethereum_DIR/node1.log"
    exit 1
fi

echo "✅ 节点1 enode地址: $ENODE"

# 5. 启动其他节点
echo "=== 启动其他节点 ==="
for i in {2..4}; do
    PORT=$((30302 + $i))
    HTTP_PORT=$((8544 + $i))
    AUTH_PORT=$((8550 + $i))
    echo "启动节点 $i (端口: $PORT, HTTP: $HTTP_PORT, AUTH: $AUTH_PORT)..."
    nohup geth --datadir "$Ethereum_DIR/nodes/node$i" \
        --networkid 666 \
        --identity "node$i" \
        --port "$PORT" \
        --http \
        --http.addr "0.0.0.0" \
        --http.port "$HTTP_PORT" \
        --http.corsdomain "*" \
        --http.api "admin,debug,web3,eth,txpool,personal,ethash,miner,net" \
        --nodiscover \
        --ipcdisable \
        --authrpc.port "$AUTH_PORT" \
        --verbosity 3 \
        --bootnodes "$ENODE" > "$Ethereum_DIR/node$i.log" 2>&1 &
    sleep 5
done

# 6. 创建static-nodes.json文件，确保节点之间可以连接
echo "=== 创建static-nodes.json文件 ==="
NODE1_ENODE=$(grep -o "enode://[^@]*@127.0.0.1:30303?discport=0" "$Ethereum_DIR/node1.log")
NODE2_ENODE=$(grep -o "enode://[^@]*@127.0.0.1:30304?discport=0" "$Ethereum_DIR/node2.log")
NODE3_ENODE=$(grep -o "enode://[^@]*@127.0.0.1:30305?discport=0" "$Ethereum_DIR/node3.log")
NODE4_ENODE=$(grep -o "enode://[^@]*@127.0.0.1:30306?discport=0" "$Ethereum_DIR/node4.log")

# 创建static-nodes.json内容
cat > "$Ethereum_DIR/static-nodes.json" << EOF
[
    "$NODE1_ENODE",
    "$NODE2_ENODE",
    "$NODE3_ENODE",
    "$NODE4_ENODE"
]
EOF

# 将static-nodes.json复制到所有节点
echo "=== 配置所有节点的static-nodes.json ==="
for i in {1..4}; do
    cp "$Ethereum_DIR/static-nodes.json" "$Ethereum_DIR/nodes/node$i/geth/"
done

# 7. 重启所有节点以应用static-nodes.json配置
echo "=== 重启所有节点以应用static-nodes.json配置 ==="
pkill -f geth || true
sleep 3

# 重新启动所有节点
 echo "=== 重新启动所有节点 ==="
 for i in {1..4}; do
     PORT=$((30302 + $i))
     HTTP_PORT=$((8544 + $i))
     AUTH_PORT=$((8550 + $i))
     echo "重新启动节点 $i (端口: $PORT, HTTP: $HTTP_PORT, AUTH: $AUTH_PORT)..."
     
     # 节点1添加挖矿参数
     if [ $i -eq 1 ]; then
         nohup geth --datadir "$Ethereum_DIR/nodes/node$i" \
             --networkid 666 \
             --identity "node$i" \
             --port "$PORT" \
             --http \
             --http.addr "0.0.0.0" \
             --http.port "$HTTP_PORT" \
             --http.corsdomain "*" \
             --http.api "admin,debug,web3,eth,txpool,personal,ethash,miner,net" \
             --nodiscover \
             --ipcdisable \
             --authrpc.port "$AUTH_PORT" \
             --verbosity 3 \
             --mine \
             --miner.threads 1 \
             --miner.etherbase "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4" > "$Ethereum_DIR/node$i.log" 2>&1 &
     else
         nohup geth --datadir "$Ethereum_DIR/nodes/node$i" \
             --networkid 666 \
             --identity "node$i" \
             --port "$PORT" \
             --http \
             --http.addr "0.0.0.0" \
             --http.port "$HTTP_PORT" \
             --http.corsdomain "*" \
             --http.api "admin,debug,web3,eth,txpool,personal,ethash,miner,net" \
             --nodiscover \
             --ipcdisable \
             --authrpc.port "$AUTH_PORT" \
             --verbosity 3 > "$Ethereum_DIR/node$i.log" 2>&1 &
     fi
     sleep 5
 done

# 8. 挖矿已在节点1启动命令中配置
 echo "=== 节点1挖矿配置完成 ==="
 echo "节点1已配置为自动挖矿模式，使用1个线程"
 echo "挖矿奖励地址: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"

# 9. 验证所有节点是否启动成功
echo "=== 验证节点启动状态 ==="
sleep 15
RUNNING_NODES=$(ps -ef | grep geth | grep -v grep | wc -l)
echo "当前运行的geth进程数: $RUNNING_NODES"

if [ $RUNNING_NODES -eq 4 ]; then
    echo "✅ 所有4个节点都成功启动"
else
    echo "❌ 只有 $RUNNING_NODES 个节点启动成功"
    ps -ef | grep geth | grep -v grep
fi

# 10. 验证节点连接情况
 echo "=== 验证节点连接情况 ==="
 echo "节点1连接数: $(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545)"
 echo "节点2连接数: $(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8546)"
 echo "节点3连接数: $(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8547)"
 echo "节点4连接数: $(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8548)"

# 11. 显示节点日志
echo "=== 节点日志摘要 ==="
for i in {1..4}; do
    echo "--- 节点 $i 日志 ---"
    tail -n 10 "$Ethereum_DIR/node$i.log"
done

# 12. 显示块高信息
 echo "=== 块高信息 ==="
 echo "节点1块高: $(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545)"

# 13. 显示现有账户和区块信息
 echo "=== 网络状态信息 ==="
 
 # 显示节点1账户
 echo "节点1账户列表:"
 curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' http://localhost:8545
 
 echo "\n=== 等待挖矿生成区块... ==="
 sleep 30

 # 14. 显示当前区块高度
 echo "=== 区块高度信息 ==="
 for i in {1..4}; do
     BLOCK_HEIGHT=$(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:854$i)
     echo "节点$i 区块高度: $BLOCK_HEIGHT"
 done
 
 # 15. 显示连接状态
 echo "\n=== 节点连接状态 ==="
 for i in {1..4}; do
     PEER_COUNT=$(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:854$i)
     echo "节点$i 连接数: $PEER_COUNT"
 done

echo "=== 以太坊私有网络部署完成 ==="
echo "节点1 HTTP地址: http://localhost:8545"
echo "节点2 HTTP地址: http://localhost:8546"
echo "节点3 HTTP地址: http://localhost:8547"
echo "节点4 HTTP地址: http://localhost:8548"
echo ""
echo "使用以下命令查看节点状态:"
echo "curl -s -X POST -H 'Content-Type: application/json' -d '{\"jsonrpc\":\"2.0\",\"method\":\"net_peerCount\",\"params\":[],\"id\":1}' http://localhost:8545 | jq"
echo ""
echo "使用以下命令查看块高:"
echo "curl -s -X POST -H 'Content-Type: application/json' -d '{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1}' http://localhost:8545 | jq"
echo ""
echo "使用以下命令停止挖矿:"
echo "geth attach http://localhost:8545 --exec 'miner.stop()'"
