# ⛓️ 以太坊私有网络挖矿 | Ethereum Private Network Mining

> **从零搭建以太坊私有链，完整实现挖矿、交易、智能合约部署——区块链学习的最佳实战项目。**
>
> *Build an Ethereum private chain from scratch, complete with mining, transactions, and smart contract deployment — the best hands-on project for blockchain learning.*

---

## ⭐ 核心卖点 | Why Star This

| 卖点 | Feature | 一句话 |
|------|---------|--------|
| ⛓️ **私有链搭建** | Private Chain | 从零搭建以太坊私有网络，完整配置 |
| ⛏️ **挖矿实现** | Mining | PoW 共识机制，完整挖矿流程 |
| 💰 **交易处理** | Transactions | 账户创建、转账、交易确认全流程 |
| 📜 **智能合约** | Smart Contracts | Solidity 合约编写、部署、调用 |
| 🧪 **可复现实验** | Reproducible | 完整节点配置，一键启动私有链 |

---

## 🏆 技术栈 | Tech Stack

![Go-Ethereum](https://img.shields.io/badge/Geth-1.10+-blue?logo=ethereum)
![Solidity](https://img.shields.io/badge/Solidity-0.8+-gray?logo=solidity)
![Web3.js](https://img.shields.io/badge/Web3.js-1.0+-orange?logo=web3dotjs)
![Node.js](https://img.shields.io/badge/Node.js-14+-green?logo=nodedotjs)

---

## 📊 项目内容 | Project Content

| 模块 | 内容 | 状态 |
|------|------|------|
| 🔧 创世块配置 | genesis.json 完整配置 | ✅ |
| 👤 账户管理 | 账户创建、解锁、查询 | ✅ |
| ⛏️ 挖矿 | PoW 挖矿、难度调整 | ✅ |
| 💰 交易 | 转账、交易池、区块确认 | ✅ |
| 📜 智能合约 | Solidity 编写、编译、部署、调用 | ✅ |
| 🌐 节点互联 | 多节点 P2P 网络 | ✅ |

---

## 🚀 快速开始 | Quick Start

```bash
git clone https://github.com/Windyhhh/Ethereum-Private-Network-Mining.git
cd Ethereum-Private-Network-Mining

# 1. 初始化创世块
geth init genesis.json --datadir ./node1

# 2. 创建账户
geth account new --datadir ./node1

# 3. 启动节点并开始挖矿
geth --datadir ./node1 --networkid 12345 --mine --miner.threads 1 console

# 4. 在控制台中转账
> eth.sendTransaction({from: eth.accounts[0], to: "0x...", value: web3.toWei(1, "ether")})
```

---

## 📂 项目结构 | Project Structure

```
Ethereum-Private-Network-Mining/
├── genesis.json               # 创世块配置
├── start_node1.sh             # 节点1启动脚本
├── start_node2.sh             # 节点2启动脚本
├── contracts/                 # 智能合约
│   ├── SimpleStorage.sol      # 简单存储合约
│   ├── Token.sol              # ERC20 代币合约
│   └── Voting.sol             # 投票合约
├── scripts/                   # 交互脚本
│   ├── deploy_contract.js     # 合约部署脚本
│   ├── send_transaction.js    # 交易脚本
│   └── check_balance.js       # 余额查询
├── nodes/                     # 节点数据 (区块链数据)
├── docs/                      # 文档
│   ├── setup_guide.md         # 搭建指南
│   ├── mining_explained.md    # 挖矿原理解析
│   └── smart_contract_guide.md # 智能合约指南
└── README.md
```

---

## 🔬 核心概念 | Core Concepts

### 创世块配置 | Genesis Block

```json
{
  "config": {
    "chainId": 12345,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
  "difficulty": "0x20000",
  "gasLimit": "0x2fefd8",
  "alloc": {
    "0x...": { "balance": "100000000000000000000" }
  }
}
```

### 挖矿原理 | Mining Principle

```
1. 收集交易池中的交易
2. 组装候选区块 (区块头 + 交易列表)
3. 计算区块哈希 (PoW)
   - 不断调整 nonce，直到哈希 < 目标值
   - 目标值由难度决定
4. 找到有效 nonce → 区块有效
5. 广播区块，获得区块奖励
```

### 智能合约流程 | Smart Contract Flow

```
Solidity 源码
  ↓ solc 编译
EVM 字节码 + ABI
  ↓ 发送部署交易
区块链上的合约账户
  ↓ 调用合约函数
交易调用 → EVM 执行 → 状态变更
```

---

## 🎯 应用场景 | Use Cases

- 🎓 **区块链教学**：以太坊原理的最佳学习项目
- 🧪 **合约测试**：智能合约开发的本地测试环境
- 🔬 **共识研究**：PoW 共识机制的实验平台
- 💰 **代币发行**：私有链上的代币发行实验
- 🗳️ **DApp 开发**：去中心化应用的开发测试

---

## 📚 参考文献 | References

- Wood, G. "Ethereum: A Secure Decentralised Generalised Transaction Ledger." Ethereum Yellow Paper 2014.
- Nakamoto, S. "Bitcoin: A Peer-to-Peer Electronic Cash System." 2008.
- Buterin, V. "A Next-Generation Smart Contract and Decentralized Application Platform." Ethereum White Paper 2013.

---

## 📄 License

MIT License — 自由使用、修改和分发。

---

> 💡 **从零搭建以太坊私有链，Star ⭐ 支持开源区块链项目！**
