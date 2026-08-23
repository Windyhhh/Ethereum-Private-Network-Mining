#!/bin/bash
echo "=== 手动启动挖矿脚本 ==="

# 1. 创建账户并设置为etherbase
echo "=== 创建账户并设置etherbase ==="
ACCOUNT=$(geth attach http://localhost:8545 << EOF
personal.newAccount("password")
EOF
)
ACCOUNT=$(echo $ACCOUNT | grep -o '0x[0-9a-fA-F]\{40\}')
echo "✅ 创建账户: $ACCOUNT"

# 2. 启动挖矿
echo "=== 启动挖矿 ==="
geth attach http://localhost:8545 << EOF
miner.setEtherbase("$ACCOUNT")
miner.start(1)
EOF

echo "=== 挖矿已启动，等待20秒生成区块 ==="
sleep 20

# 3. 检查块高
echo "=== 块高信息 ==="
BLOCK_HEIGHT=$(curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545)
echo "节点1块高: $BLOCK_HEIGHT"

# 4. 检查账户余额
echo "=== 账户余额信息 ==="
BALANCE=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"$ACCOUNT\",\"latest\"],\"id\":1}" http://localhost:8545)
echo "账户 $ACCOUNT 余额: $BALANCE"

# 5. 显示挖矿日志
echo "=== 挖矿日志 ==="
tail -n 20 /home/windy/ethereum/node1.log | grep -i "mine\|block\|coinbase"
