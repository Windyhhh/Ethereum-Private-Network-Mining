#!/bin/bash

echo "=== 检查节点连接情况 ==="

# 检查节点1的连接数
echo "节点1连接数:"
geth attach http://localhost:8545 --exec 'net.peerCount'

# 检查节点2的连接数
echo "节点2连接数:"
geth attach http://localhost:8546 --exec 'net.peerCount'

# 检查节点3的连接数
echo "节点3连接数:"
geth attach http://localhost:8547 --exec 'net.peerCount'

# 检查节点4的连接数
echo "节点4连接数:"
geth attach http://localhost:8548 --exec 'net.peerCount'
