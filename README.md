# PPT Token & MedInvoice Contract

A complete smart contract system featuring an ERC-20 token (PPT) and a medical invoice management system with subscription-based access control.

## 📋 Table of Contents

- [About The Project](#about-the-project)
- [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Building](#building)
  - [Testing](#testing)
  - [Deployment](#deployment)
  - [Verification](#verification)
- [Contract Architecture](#contract-architecture)
- [Network Information](#network-information)
- [Contributing](#contributing)
- [License](#license)

## 🚀 About The Project

This project consists of two main smart contracts:

1. **PPTToken**: An ERC-20 token called "Park Pro Token" (PPT) with standard functionality
2. **MedInvoiceContract**: A medical invoice storage system that requires PPT tokens for access and offers subscription-based services

### Key Features

- **ERC-20 Token**: Standard fungible token with customizable initial supply
- **File Storage**: Store and retrieve medical invoice data on-chain
- **Token Gating**: Requires PPT token holdings to access file operations
- **Subscription System**: Annual subscription model with token-based payments
- **Access Control**: Owner-only functions for contract administration
- **Security**: Implements ReentrancyGuard for protection against reentrancy attacks

## 🛠 Built With

- [Foundry](https://getfoundry.sh/) - Ethereum development toolkit
- [OpenZeppelin](https://openzeppelin.com/contracts/) - Secure smart contract library
- [Solidity](https://soliditylang.org/) ^0.8.20

## 🎯 Getting Started

### Prerequisites

- [Git](https://git-scm.com/)
- [Foundry](https://getfoundry.sh/)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/seetadev/foundry-setup-contracts-Storacha.git
cd foundry-setup-contracts-Storacha
```

2. **Install Foundry** (if not already installed)
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

3. **Install dependencies**
```bash
git submodule add https://github.com/OpenZeppelin/openzeppelin-contracts.git lib/openzeppelin-contracts
git commit -m "Add OpenZeppelin contracts as submodule"
```

4. **Set up environment variables**
```bash
cp .env.example .env
```
Required environment variables:
```bash
PRIVATE_KEY=your_private_key_here
RPC_URL=your_private_key_here
ETHERSCAN_API_KEY=your_etherscan_api_key_here
```

## 📖 Usage

### Building

Compile the smart contracts:
```bash
forge build
```

### Testing

Run the test suite:

### Deployment
- Run all tests
- forge test

Run tests with verbosity
forge test -vvv

#### Deploy to Base Sepolia Testnet

1. **Using the deployment script:**
```bash
source .env
```
```bash
forge script script/DeployAndVerify.s.sol:DeployAndVerifyContract
--rpc-url $RPC_URL
--private-key $PRIVATE_KEY
--chain-id 84532
--broadcast
--verify
--etherscan-api-key $ETHERSCAN_API_KEY
-vvvv
```

2. **Deploy individual contracts:**
Deploy PPTToken
```bash
forge create src/PPTToken.sol:PPTToken
--rpc-url $RPC_URL
--private-key $PRIVATE_KEY
--constructor-args 1000
--verify
--etherscan-api-key $ETHERSCAN_API_KEY
```
```bash
Deploy MedInvoiceContract (replace TOKEN_ADDRESS)
forge create src/MedInvoiceContract.sol:MedInvoiceContract
--rpc-url $RPC_URL
--private-key $PRIVATE_KEY
--constructor-args <TOKEN_ADDRESS>
--verify
--etherscan-api-key $ETHERSCAN_API_KEY
```

### Verification

Verify deployed contracts on Basescan:
```bash
forge verify-contract
--chain-id 84532
<CONTRACT_ADDRESS>
src/PPTToken.sol:PPTToken
--etherscan-api-key $ETHERSCAN_API_KEY
--constructor-args $(cast abi-encode "constructor(uint256)" 1000)

Verify MedInvoiceContract
forge verify-contract
--chain-id 84532
<CONTRACT_ADDRESS>
src/MedInvoiceContract.sol:MedInvoiceContract
--etherscan-api-key $ETHERSCAN_API_KEY
--constructor-args $(cast abi-encode "constructor(address)" <PPT_TOKEN_ADDRESS>)
```

**Key Features:**
- File storage per user address
- Token-gated access (requires PPT balance ≥ 1)
- Annual subscription system (10 PPT tokens)
- Owner withdrawal functionality
- Reentrancy protection

**Main Functions:**
- `saveFile(string memory file)`: Store medical invoice data
- `getFiles()`: Retrieve user's stored files
- `subscribe()`: Purchase annual subscription
- `isSubscribed(address user)`: Check subscription status

## 🌐 Network Information

### Base Sepolia Testnet
- **Chain ID**: 84532
- **RPC URL**: https://sepolia.base.org
- **Block Explorer**: https://sepolia.basescan.org
- **Faucet**: [Base Sepolia Faucet](https://faucets.chain.link/base-sepolia)

### Deployed Contracts

| Contract | Address | Network |
|----------|---------|---------|
| PPTToken | `0x4af65ccadeBE20cCE966B739fD7a5310467F5866` | Base Sepolia |
| MedInvoiceContract | `0x1cA76036A0385a0271D6A1A8b5C0e15138bf87BE` | Base Sepolia |

## 🧪 Testing

The project includes comprehensive tests for both contracts:

- **PPTTokenTest**: Tests for ERC-20 functionality, transfers, and balances
- **MedInvoiceContractTest**: Tests for file storage, subscription system, and access control

Test coverage includes:
- ✅ Token minting and transfers
- ✅ File storage and retrieval
- ✅ Subscription management
- ✅ Access control mechanisms
- ✅ Error handling and edge cases

---

## 📚 Additional Resources

- [Foundry Documentation](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Base Network Documentation](https://docs.base.org/)
- [Solidity Documentation](https://docs.soliditylang.org/)

