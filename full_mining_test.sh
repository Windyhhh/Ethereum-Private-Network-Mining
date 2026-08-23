#!/bin/bash
echo "=== 完整挖矿测试脚本 ==="

# 1. 检查节点状态
echo "=== 节点连接状态 ==="
NODE1_PEERS=$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545 | grep -o '0x[0-9a-f]\+')
echo "节点1连接数: $NODE1_PEERS (十进制: $((16#${NODE1_PEERS:2})))"

# 2. 创建测试账户
echo "=== 创建测试账户 ==="
ACCOUNT=$(geth attach http://localhost:8545 << EOF
personal.newAccount("password")
EOF
)

# 提取账户地址，去除引号和换行
ACCOUNT=$(echo $ACCOUNT | grep -o '0x[0-9a-fA-F]\{40\}')
echo "✅ 创建测试账户: $ACCOUNT"

# 3. 设置etherbase并启动挖矿
echo "=== 设置etherbase并启动挖矿 ==="
geth attach http://localhost:8545 << EOF
miner.setEtherbase("$ACCOUNT")
miner.start(1)
EOF

echo "=== 挖矿已启动，等待30秒生成区块 ==="
sleep 30

# 4. 检查块高
echo "=== 块高信息 ==="
BLOCK_HEIGHT=$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545)
echo "节点1块高: $BLOCK_HEIGHT"

# 5. 检查账户余额
echo "=== 账户余额信息 ==="
BALANCE=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"$ACCOUNT\",\"latest\"],\"id\":1}" http://localhost:8545)
echo "账户 $ACCOUNT 余额: $BALANCE"

# 6. 显示可读余额
echo "=== 可读余额信息 ==="
# 提取十六进制余额
HEX_BALANCE=$(echo $BALANCE | grep -o '0x[0-9a-f]\+')
# 转换为十进制
declare -i DEC_BALANCE=$((16#${HEX_BALANCE:2}))
# 转换为ETH
etH_BALANCE=$(echo "scale=6; $DEC_BALANCE / 1000000000000000000" | bc)
echo "账户 $ACCOUNT 可读余额: $ETH_BALANCE ETH"

# 7. 检查其他节点块高
echo "=== 其他节点块高信息 ==="
echo "节点2块高: $(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8546)"
echo "节点3块高: $(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8547)"
echo "节点4块高: $(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8548)"

# 8. 显示节点1最近日志
echo "=== 节点1最近日志 ==="
tail -n 20 /home/windy/ethereum/node1.log
