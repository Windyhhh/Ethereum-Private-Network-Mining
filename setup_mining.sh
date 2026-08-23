#!/bin/bash

echo '=== 设置挖矿环境 ==='

# 1. 检查当前账户
echo '\n1. 检查当前账户:'
geth attach http://localhost:8545 --exec "eth.accounts"

# 2. 创建账户
echo '\n2. 创建账户:'
geth attach http://localhost:8545 --exec "personal.newAccount('password')"

# 3. 再次检查账户
echo '\n3. 再次检查账户:'
geth attach http://localhost:8545 --exec "eth.accounts"

# 4. 设置etherbase
echo '\n4. 设置etherbase:'
geth attach http://localhost:8545 --exec "miner.setEtherbase(eth.accounts[0])"

# 5. 启动挖矿
echo '\n5. 启动挖矿:'
geth attach http://localhost:8545 --exec "miner.start(1)"

# 6. 等待挖矿
echo '\n6. 等待10秒让挖矿开始...'
sleep 10

# 7. 检查挖矿状态
echo '\n7. 检查挖矿状态:'
geth attach http://localhost:8545 --exec "miner.hashrate"

# 8. 检查当前块高
echo '\n8. 检查当前块高:'
geth attach http://localhost:8545 --exec "eth.blockNumber"

# 9. 检查账户余额
echo '\n9. 检查账户余额:'
geth attach http://localhost:8545 --exec "eth.getBalance(eth.accounts[0])"

# 10. 等待更多区块生成
echo '\n10. 等待30秒生成更多区块...'
sleep 30

# 11. 最终块高
echo '\n11. 最终块高:'
geth attach http://localhost:8545 --exec "eth.blockNumber"