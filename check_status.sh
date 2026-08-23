#!/bin/bash

echo '=== 以太坊私有网络状态检查 ==='

echo '\n1. 检查节点进程:'
ps -ef | grep geth | grep -v grep

echo '\n2. 检查节点连接状态:'
for i in {1..4}; do
    echo "节点$i:"
    curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:854$i
    echo
    curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' http://localhost:854$i
    echo
    curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:854$i
    echo
    echo "-----------------------------------"
done

# 检查节点日志摘要
echo '\n3. 节点日志摘要:'
for i in {1..4}; do
    echo "--- 节点$i 最新10行日志 ---"
    tail -n 10 /home/windy/ethereum/node$i.log
    echo "-----------------------------------"
done