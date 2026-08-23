#!/bin/bash

echo '=== 以太坊私有网络修复工具 ==='

echo '
1. 检查节点连接数:'
curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545

echo '
2. 检查节点1账户:'
curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' http://localhost:8545

echo '
3. 检查区块高度:'
curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545

echo '
4. 创建测试账户:'
cat > /tmp/create_account.js << 'EOF'
personal.newAccount('password');
console.log('账户创建成功:', eth.accounts);
EOF

# 执行账户创建
geth attach http://localhost:8545 --exec "loadScript('/tmp/create_account.js')"

echo '
5. 设置etherbase并启动挖矿:'
cat > /tmp/start_mining.js << 'EOF'
miner.setEtherbase(eth.accounts[0]);
miner.start(1);
console.log('挖矿已启动，hashrate:', miner.hashrate);
EOF

# 执行挖矿启动
geth attach http://localhost:8545 --exec "loadScript('/tmp/start_mining.js')"

echo '
6. 等待10秒让挖矿开始...'
sleep 10

echo '
7. 检查挖矿状态(hashrate):'
curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_hashrate","params":[],"id":1}' http://localhost:8545

echo '
8. 检查最新区块高度:'
curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545

echo '
9. 检查账户余额:'
curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","latest"],"id":1}' http://localhost:8545