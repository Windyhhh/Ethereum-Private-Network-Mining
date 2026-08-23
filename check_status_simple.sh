#!/bin/bash

echo '=== 以太坊私有网络状态检查 ==='

echo '
1. 节点1连接数:'
curl -s -X POST -H "Content-Type: application/json" -d "{\"jsonrpc\":\"2.0\",\"method\":\"net_peerCount\",\"params\":[],\"id\":1}" http://localhost:8545

echo '
2. 最新区块高度:'
curl -s -X POST -H "Content-Type: application/json" -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1}" http://localhost:8545

echo '
3. 挖矿状态(hashrate):'
curl -s -X POST -H "Content-Type: application/json" -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_hashrate\",\"params\":[],\"id\":1}" http://localhost:8545

echo '
4. 节点1最新挖矿日志:'
tail -n 10 /home/windy/ethereum/node1.log | grep -i "mined\|sealed\|block"