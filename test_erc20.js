// ERC20合约测试脚本
// 测试张天硕代币的所有功能

const Web3 = require('web3');

// 连接到私有网络
const web3 = new Web3('http://localhost:8545');

// 合约地址 (需要替换为实际部署的合约地址)
const CONTRACT_ADDRESS = '0x...'; // 替换为实际部署的合约地址

// 合约ABI
const CONTRACT_ABI = [
    {
        "constant": true,
        "inputs": [],
        "name": "name",
        "outputs": [{"name": "", "type": "string"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "symbol",
        "outputs": [{"name": "", "type": "string"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "decimals",
        "outputs": [{"name": "", "type": "uint8"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "totalSupply",
        "outputs": [{"name": "", "type": "uint256"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [{"name": "", "type": "address"}],
        "name": "balanceOf",
        "outputs": [{"name": "", "type": "uint256"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [{"name": "to", "type": "address"}, {"name": "amount", "type": "uint256"}],
        "name": "transfer",
        "outputs": [{"name": "", "type": "bool"}],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [{"name": "", "type": "address"}, {"name": "", "type": "address"}],
        "name": "allowance",
        "outputs": [{"name": "", "type": "uint256"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [{"name": "spender", "type": "address"}, {"name": "amount", "type": "uint256"}],
        "name": "approve",
        "outputs": [{"name": "", "type": "bool"}],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [{"name": "from", "type": "address"}, {"name": "to", "type": "address"}, {"name": "amount", "type": "uint256"}],
        "name": "transferFrom",
        "outputs": [{"name": "", "type": "bool"}],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "anonymous": false,
        "inputs": [
            {"indexed": true, "name": "from", "type": "address"},
            {"indexed": true, "name": "to", "type": "address"},
            {"indexed": false, "name": "value", "type": "uint256"}
        ],
        "name": "Transfer",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {"indexed": true, "name": "owner", "type": "address"},
            {"indexed": true, "name": "spender", "type": "address"},
            {"indexed": false, "name": "value", "type": "uint256"}
        ],
        "name": "Approval",
        "type": "event"
    }
];

// 创建合约实例
const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);

// 测试函数
async function testERC20() {
    console.log("=== 张天硕代币 (ZTS) 测试开始 ===");
    
    try {
        // 1. 测试基本信息
        console.log("\n1. 基本信息测试:");
        const name = await contract.methods.name().call();
        const symbol = await contract.methods.symbol().call();
        const decimals = await contract.methods.decimals().call();
        const totalSupply = await contract.methods.totalSupply().call();
        
        console.log(`   代币名称: ${name}`);
        console.log(`   代币符号: ${symbol}`);
        console.log(`   小数位数: ${decimals}`);
        console.log(`   总供应量: ${web3.utils.fromWei(totalSupply, 'ether')} ${symbol}`);
        
        // 2. 测试账户信息
        console.log("\n2. 账户信息测试:");
        const accounts = await web3.eth.getAccounts();
        const owner = accounts[0];
        const recipient = accounts[1];
        
        console.log(`   部署账户: ${owner}`);
        console.log(`   接收账户: ${recipient}`);
        
        // 3. 测试余额
        console.log("\n3. 余额测试:");
        let ownerBalance = await contract.methods.balanceOf(owner).call();
        let recipientBalance = await contract.methods.balanceOf(recipient).call();
        
        console.log(`   部署账户余额: ${web3.utils.fromWei(ownerBalance, 'ether')} ${symbol}`);
        console.log(`   接收账户余额: ${web3.utils.fromWei(recipientBalance, 'ether')} ${symbol}`);
        
        // 4. 测试转账
        console.log("\n4. 转账测试:");
        const transferAmount = web3.utils.toWei('100', 'ether'); // 转账100 ZTS
        
        console.log(`   转账金额: 100 ${symbol}`);
        
        // 发送转账交易
        const tx = await contract.methods.transfer(recipient, transferAmount).send({
            from: owner,
            gas: 200000
        });
        
        console.log(`   转账交易哈希: ${tx.transactionHash}`);
        
        // 5. 测试转账后余额
        console.log("\n5. 转账后余额测试:");
        ownerBalance = await contract.methods.balanceOf(owner).call();
        recipientBalance = await contract.methods.balanceOf(recipient).call();
        
        console.log(`   部署账户余额: ${web3.utils.fromWei(ownerBalance, 'ether')} ${symbol}`);
        console.log(`   接收账户余额: ${web3.utils.fromWei(recipientBalance, 'ether')} ${symbol}`);
        
        // 6. 测试授权功能
        console.log("\n6. 授权功能测试:");
        const approveAmount = web3.utils.toWei('50', 'ether'); // 授权50 ZTS
        
        // 发送授权交易
        const approveTx = await contract.methods.approve(recipient, approveAmount).send({
            from: owner,
            gas: 100000
        });
        
        console.log(`   授权交易哈希: ${approveTx.transactionHash}`);
        
        // 检查授权额度
        const allowance = await contract.methods.allowance(owner, recipient).call();
        console.log(`   授权额度: ${web3.utils.fromWei(allowance, 'ether')} ${symbol}`);
        
        console.log("\n=== 测试完成！所有功能正常 ===");
        
    } catch (error) {
        console.error("❌ 测试失败:", error.message);
        console.log("请检查以下事项:");
        console.log("1. 合约地址是否正确");
        console.log("2. 网络连接是否正常");
        console.log("3. 账户是否有足够的ETH支付Gas");
        console.log("4. 合约ABI是否正确");
    }
}

// 运行测试
testERC20();
