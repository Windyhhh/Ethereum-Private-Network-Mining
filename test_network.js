// 网络测试脚本
// 检查网络状态并提供部署指南

console.log("=== 以太坊私有网络状态测试 ===");
console.log("\n1. 检查网络连接...");

// 测试网络连接
const Web3 = require('web3');
const web3 = new Web3('http://localhost:8545');

async function testNetwork() {
    try {
        // 检查连接
        const blockNumber = await web3.eth.getBlockNumber();
        console.log(`✅ 网络连接正常！块高: ${blockNumber}`);
        
        // 检查节点数量
        const peerCount = await web3.eth.net.getPeerCount();
        console.log(`✅ 节点连接数: ${peerCount}`);
        
        // 检查账户
        const accounts = await web3.eth.getAccounts();
        console.log(`✅ 可用账户数: ${accounts.length}`);
        if (accounts.length > 0) {
            console.log(`   第一个账户: ${accounts[0]}`);
            
            // 检查账户余额
            const balance = await web3.eth.getBalance(accounts[0]);
            console.log(`   账户余额: ${web3.utils.fromWei(balance, 'ether')} ETH`);
        }
        
        console.log("\n2. ERC20合约部署指南:");
        console.log("   - 打开 Remix: https://remix.ethereum.org/");
        console.log("   - 上传 ZTSCoin.sol 文件");
        console.log("   - 编译合约");
        console.log("   - 连接到 http://localhost:8545");
        console.log("   - 部署 ZTSCoin 合约");
        console.log("   - 测试合约功能");
        
        console.log("\n3. 合约功能测试:");
        console.log("   - name(): 查看代币名称 (张天硕代币)");
        console.log("   - symbol(): 查看代币符号 (ZTS)");
        console.log("   - totalSupply(): 查看总供应量 (1,000,000 ZTS)");
        console.log("   - balanceOf(address): 查看账户余额");
        console.log("   - transfer(address, amount): 转账代币");
        
        console.log("\n=== 测试完成！可以开始部署合约 ===");
        
    } catch (error) {
        console.error("❌ 网络连接失败:", error.message);
        console.log("请检查以下事项:");
        console.log("1. 节点是否正在运行？");
        console.log("2. JSON-RPC 端口是否正确？");
        console.log("3. 防火墙是否允许访问？");
    }
}

testNetwork();
