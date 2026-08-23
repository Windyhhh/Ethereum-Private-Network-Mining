personal.newAccount('password');
miner.setEtherbase(eth.accounts[0]);
miner.start(1);
console.log('账户列表:', eth.accounts);
console.log('Etherbase:', miner.etherbase);
console.log('挖矿已启动，hashrate:', miner.hashrate);
console.log('当前区块高度:', eth.blockNumber);