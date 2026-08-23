# ⛓️ Ethereum Private Network Mining | 以太坊私有网络挖矿项目

> **Complete solution for Ethereum private network deployment and mining. From genesis block creation to node setup, mining, and ERC-20 token issuance. Includes Solidity smart contracts, deployment scripts, and comprehensive testing.**
>
> 以太坊私有网络部署与挖矿完整解决方案。从创世区块创建到节点搭建、挖矿、ERC-20 代币发行。包含 Solidity 智能合约、部署脚本和完整测试。

---

## 🌟 Features | 核心特性

- **Private Network Setup** — Multi-node Ethereum private network (4 nodes)
- **Genesis Block** — Custom genesis.json configuration
- **Mining** — CPU mining with automatic start/stop scripts
- **Smart Contracts** — Solidity ERC-20 token (ZTSCoin)
- **Deployment** — Web3.js deployment scripts
- **Node Management** — static-nodes.json for peer discovery
- **Testing** — Network connectivity, mining, ERC-20 tests
- **Cross-Platform** — Windows (.bat) and Linux (.sh) scripts

---

## 📁 Project Structure | 项目结构

```
Ethereum-Private-Network-Mining/
├── genesis.json                    # Genesis block configuration
├── static-nodes.json               # Static node peer list
├── ZTSCoinSimple.sol               # ERC-20 token smart contract
├── mining.js                       # Mining control script
├── deploy_simple.js                # Simple contract deployment
├── deploy_zts.js                   # ZTS token deployment
├── test_erc20.js                   # ERC-20 token test
├── test_network.js                 # Network connectivity test
├── deploy_eth_network.sh           # Full network deployment script
├── start_mining.sh                 # Start mining script
├── setup_mining.sh                 # Mining setup script
├── manual_mining.sh                # Manual mining control
├── full_mining_test.sh             # Full mining test
├── fix_mining.sh                   # Mining issue fix script
├── check_status.sh                 # Status check script
├── check_status_simple.sh          # Simple status check
├── check_nodes.sh                  # Node status check
├── check_eth_status.bat            # Windows status check
├── simple_check.sh                 # Simple check script
├── demo_script.sh                  # Demo script
├── terminal_operations.sh          # Terminal operations guide
├── test_script.sh                  # Test script
├── 以太坊私有网络挖矿项目爆款文档.md
├── 博客要求
└── README.md
```

---

## 🚀 Quick Start | 快速开始

### 1. Initialize Private Network | 初始化私有网络

```bash
# Initialize genesis block for each node
geth --datadir node1 init genesis.json
geth --datadir node2 init genesis.json
geth --datadir node3 init genesis.json
geth --datadir node4 init genesis.json

# Or use the deployment script
bash deploy_eth_network.sh
```

### 2. Start Nodes | 启动节点

```bash
# Start node 1 (with RPC)
geth --datadir node1 --networkid 12345 --rpc --rpcport 8545 --rpcapi "eth,net,web3,personal" --allow-insecure-unlock console

# Start other nodes
geth --datadir node2 --networkid 12345 --port 30304 console
```

### 3. Start Mining | 开始挖矿

```bash
# In Geth console
> miner.start(1)  # Start mining with 1 thread

# Or use script
bash start_mining.sh
```

### 4. Deploy ERC-20 Token | 部署 ERC-20 代币

```bash
# Compile and deploy
node deploy_zts.js

# Test token
node test_erc20.js
```

### 5. Check Status | 检查状态

```bash
bash check_status.sh
# or Windows:
check_eth_status.bat
```

---

## 🔧 Genesis Configuration | 创世区块配置

```json
{
  "config": {
    "chainId": 12345,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
  "alloc": {
    "0x...": { "balance": "100000000000000000000" }
  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "difficulty": "0x20000",
  "extraData": "",
  "gasLimit": "0x2fefd8",
  "nonce": "0x0000000000000042",
  "mixhash": "0x000000000000000000000000000000000000000000000000000000000000000",
  "parentHash": "0x000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00"
}
```

---

## 📜 Smart Contract | 智能合约

### ZTSCoin (ERC-20) | ZTS 代币

```solidity
// Simplified ERC-20 token
contract ZTSCoinSimple {
    string public name = "ZTS Coin";
    string public symbol = "ZTS";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _supply) public {
        totalSupply = _supply * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    // ... approve, transferFrom, etc.
}
```

---

## 📊 Mining Commands | 挖矿命令

| Command | Description |
|---------|-------------|
| `miner.start(n)` | Start mining with n threads |
| `miner.stop()` | Stop mining |
| `miner.setEtherbase(addr)` | Set mining reward address |
| `eth.blockNumber` | Current block number |
| `eth.getBalance(addr)` | Get account balance |
| `eth.hashrate` | Current mining hashrate |
| `admin.nodeInfo` | Node information |
| `net.peerCount` | Number of connected peers |

---

## 📚 References | 参考文献

1. **Wood, G.** (2014). *Ethereum: A secure decentralised generalised transaction ledger.* Ethereum Yellow Paper.
2. **Buterin, V.** (2014). *A next-generation smart contract and decentralized application platform.* Ethereum White Paper.
3. **Vogelsteller, F., & Buterin, V.** (2015). *ERC-20 Token Standard.* Ethereum Improvement Proposals.
4. **Go-Ethereum.** (2024). *Go-Ethereum Documentation.* https://geth.ethereum.org/docs/

---

## 📄 License | 许可证

MIT License.

---

<div align="center">

**Built with ⛓️ for blockchain education**

[GitHub](https://github.com/Windyhhh/Ethereum-Private-Network-Mining)

</div>
