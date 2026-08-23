// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title 张天硕代币 (ZTS)
 * @dev 简化版ERC20实现
 */
contract ZTSCoinSimple {
    // 代币名称
    string public constant name = unicode"张天硕代币";
    
    // 代币符号
    string public constant symbol = "ZTS";
    
    // 小数位数
    uint8 public constant decimals = 18;
    
    // 总供应量
    uint256 public constant totalSupply = 1000000 * 10 ** uint256(decimals);
    
    // 余额映射
    mapping(address => uint256) public balanceOf;
    
    // 授权映射
    mapping(address => mapping(address => uint256)) public allowance;
    
    // 事件定义
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    /**
     * @dev 构造函数，将所有代币分配给合约部署者
     */
    constructor() {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    /**
     * @dev 转账代币
     */
    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");
        
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    /**
     * @dev 设置授权额度
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");
        
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    /**
     * @dev 使用授权额度转账
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[from] >= amount, "ERC20: transfer amount exceeds balance");
        require(allowance[from][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
        
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
}
