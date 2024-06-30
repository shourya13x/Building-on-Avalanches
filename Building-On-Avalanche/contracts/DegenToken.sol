// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract CryptoToken is ERC20, Ownable, ERC20Burnable {

    struct Product {
        string productName;
        uint8 productId;
        uint256 productPrice;
    }
    mapping (uint8 => Product) public products;
    uint8 public nextProductId;
    
    event ProductBought(address indexed buyer, uint8 productId, string productName, uint256 productPrice);
    event GameResult(address indexed player, uint256 generatedNumber, bool victory, string outcome);

    constructor (address initialOwner, uint initialSupply) ERC20("Crypto", "CRT") Ownable(initialOwner) {
        mint(initialOwner, initialSupply);
        
        products[1] = Product("Novice Navigator", 1, 100);
        products[2] = Product("Mythic Maverick", 2, 700);
        products[3] = Product("Celestial Crusher", 3, 1200);
        products[4] = Product("Astral Ace", 4, 2200);
        products[5] = Product("Divine Dominator", 5, 2400);
        nextProductId = 6;
    }

    function decimals() override public pure returns (uint8) {
        return 0;
    }

    // Minting tokens

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Transferring tokens

    function sendToken(address recipient, uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        transfer(recipient, amount);
    }

    // Redeeming tokens

    function claimWelcomeBonus() public {
        require(balanceOf(msg.sender) == 0, "You've already claimed your welcome bonus");
        _mint(msg.sender, 50);
    }

    function addProduct(string memory name, uint256 price) public onlyOwner {
        products[nextProductId] = Product(name, nextProductId, price);
        nextProductId++;
    } 

    function betOnNumber(bool guess, uint256 betAmount) public {
        uint randomNum = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 10;

        if (guess == (randomNum < 5)) {
            _mint(msg.sender, betAmount * 2);
            emit GameResult(msg.sender, randomNum, true, "won");
        } else {
            burn(betAmount);
            emit GameResult(msg.sender, randomNum, false, "lost");
        }
    }
    
    function buyProduct(uint8 productId) external {
        require(products[productId].productPrice != 0, "Product not found");
        require(balanceOf(msg.sender) >= products[productId].productPrice, "Insufficient balance");

        burn(products[productId].productPrice);

        emit ProductBought(msg.sender, productId, products[productId].productName, products[productId].productPrice);
    }

    // Checking token balance

    function checkBalance() external view returns(uint256) {
        return balanceOf(msg.sender);
    }

    // Burning tokens

    function destroyToken(uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient amount");
        burn(amount);
    }

}
