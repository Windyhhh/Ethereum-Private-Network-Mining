<div align="center">

# ⛓️ Ethereum-Private-Network-Mining

### Deploy & mine on an Ethereum private network.

Genesis block, multi-node setup, ERC-20 tokens and Solidity contracts.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Solidity](https://img.shields.io/badge/Solidity-0.8-363636?logo=solidity&logoColor=white)](https://soliditylang.org/)
[![Ethereum](https://img.shields.io/badge/Ethereum-Private-3C3C3D?logo=ethereum&logoColor=white)](https://ethereum.org/)

</div>

---

**Ethereum-Private-Network-Mining** deploys and mines on an **Ethereum private network** — with a **genesis block**, multi-node setup, **ERC-20** tokens and **Solidity** contracts.

> [!NOTE]
> 中文项目：以太坊私有网络部署与挖矿——创世区块、多节点、ERC-20 代币、Solidity 合约。

---

## Quickstart

```bash
git clone https://github.com/Windyhhh/Ethereum-Private-Network-Mining.git
cd Ethereum-Private-Network-Mining

# deploy the private network
./deploy_eth_network.sh

# run a full mining test
./full_mining_test.sh

# manual mining
./manual_mining.sh
```

`genesis.json` defines the chain; `deploy_zts.js` deploys the ERC-20 token contract (`ZTSCoinSimple.sol`).

---

## Features

- **Private network** — genesis block + multi-node mining.
- **ERC-20 tokens** — custom token with Solidity contract.
- **Ready scripts** — deploy, status, fix and test scripts.

---

## Project Structure

```
Ethereum-Private-Network-Mining/
├── genesis.json               # chain genesis
├── ZTSCoinSimple.sol          # ERC-20 contract
├── deploy_zts.js / deploy_simple.js
├── deploy_eth_network.sh      # network deployment
├── full_mining_test.sh / manual_mining.sh / fix_mining.sh
└── check_*.sh / check_eth_status.bat
```

---

## License

MIT — free to use, modify and distribute.
