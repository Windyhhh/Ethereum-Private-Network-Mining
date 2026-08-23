#!/bin/bash

echo '=== 创建账户并启动挖矿 ==='

# 创建挖矿脚本
echo -e "personal.newAccount('password');
miner.setEtherbase(eth.accounts[0]);
miner.start(1);" > /tmp/mining_script.js

# 执行挖矿脚本
geth attach http://localhost:8545 --exec "loadScript('/tmp/mining_script.js')"

# 等待挖矿生成区块
echo '\n等待挖矿生成区块...'
sleep 30

# 检查块高
echo '\n=== 块高信息 ==='
for i in {1..4}; do
    echo "节点$i块高: $(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:854$i | jq -r .result | xargs printf '%d\n')"
done

# 检查连接状态
echo '\n=== 节点连接状态 ==='
for i in {1..4}; do
    echo "节点$i连接数: $(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:854$i | jq -r .result | xargs printf '%d\n')"
done