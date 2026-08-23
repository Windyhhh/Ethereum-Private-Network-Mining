#!/bin/bash
echo "=== 简单检查脚本 ==="

# 检查块高
echo "=== 块高信息 ==="
curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545

# 检查连接数
echo "=== 连接数信息 ==="
curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545

# 显示最新日志
echo "=== 最新10行日志 ==="
tail -n 10 /home/windy/ethereum/node1.log
