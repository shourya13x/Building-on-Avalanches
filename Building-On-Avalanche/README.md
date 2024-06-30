# DegenToken Smart Contract

This Solidity program is a comprehensive demonstration of an ERC-20 token with advanced functionalities including minting, transferring, burning, and redeeming tokens within a gaming context. It also incorporates game mechanics and in-game item purchases, enriching the gaming experience on the blockchain.

## Description

The `DegenToken` smart contract is an ERC-20 compliant token designed to enhance blockchain gaming by introducing a token reward system. Players can earn tokens, transfer them, and redeem them for in-game items. The contract includes a game mechanic where players can bet on the outcome of a random number generator. It leverages OpenZeppelin libraries for security and functionality, ensuring robust and secure token operations.

### Key Features

1. **Minting New Tokens**: Only the contract owner can mint new tokens and distribute them as rewards to players.
2. **Transferring Tokens**: Players can transfer tokens to others seamlessly.
3. **Redeeming Tokens**: Players can redeem tokens for items in the in-game store.
4. **Checking Token Balance**: Players can check their token balance at any time.
5. **Burning Tokens**: Players can burn tokens they no longer need, reducing the total supply.
6. **Game Mechanic**: Players can bet on whether a random number will be less than five, with the chance to double their bet if correct.

## Getting Started

### Prerequisites

- [Remix Ethereum](https://remix.ethereum.org/): An online Solidity IDE for compiling and deploying smart contracts.
- MetaMask: A browser extension for interacting with the Ethereum blockchain.

```solidity
/*
1. Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
2. Transferring tokens: Players should be able to transfer their tokens to others.
3. Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
4. Checking token balance: Players should be able to check their token balance at any time.
5. Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.
*/

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

    
  

```

### Executing Program

To run this program, follow these steps:

1. **Open Remix IDE**: Navigate to [Remix Ethereum](https://remix.ethereum.org/).
2. **Create a New File**: Create a new Solidity file (e.g., `DegenToken.sol`) and paste your Solidity code.
3. **Compile the Contract**: 
   - Click on the "Solidity Compiler" tab in the left-hand sidebar.
   - Select the compiler version `0.8.18` (or any compatible version).
   - Click on the "Compile DegenToken.sol" button.
4. **Deploy the Contract**:
   - Go to the "Deploy & Run Transactions" tab in the left-hand sidebar.
   - Select the `DegenToken` contract from the dropdown menu.
   - Click on the "Deploy" button.
   - Confirm the transaction in MetaMask.

### Interacting with the Contract

After deploying the contract, you can interact with its functions through the Remix interface:

- **Minting Tokens**: Call the `mint` function to create new tokens (only available to the owner).
- **Transferring Tokens**: Use the standard `transfer` function to send tokens to another address.
- **Redeeming Tokens**: Call the `purchaseItem` function to redeem tokens for in-game items.
- **Checking Balance**: Use the `balanceOf` function to check your token balance.
- **Burning Tokens**: Call the `burn` function to destroy tokens from your balance.
- **Game Mechanic**: Engage in the game by calling the `isLessThanFive` function with your bet.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
