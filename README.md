# 🪙 Foundry Ecosystem Token Suite

A comprehensive smart contract suite built with **Foundry** and **OpenZeppelin v5**, demonstrating production-ready implementations of the core Ethereum token standards: **ERC-20**, **ERC-721**, and **ERC-1155**.

---

## 📐 Ecosystem Architecture

This repository contains three core contracts showcasing distinct token mechanisms in the EVM:

1. **GovernanceToken (ERC-20):** Fungible token with minting/burning capabilities and allowance bounds protection.
2. **DeveloperPass (ERC-721):** Non-Fungible Token utilizing `ERC721URIStorage` for IPFS metadata linkage.
3. **GameEcosystem (ERC-1155):** Multi-token contract managing both in-game fungible currencies and unique non-fungible items under a single deployment.

---

## 🛠️ Tech Stack & Dependencies

* **Framework:** [Foundry](https://github.com/foundry-rs/foundry) (`forge`, `cast`, `anvil`)
* **Libraries:** OpenZeppelin Contracts v5.x
* **Language:** Solidity `^0.8.35`
* **Storage Standard:** IPFS (InterPlanetary File System) via Content Identifiers (CIDs)

---

## ⚡ Quickstart & Testing

### Prerequisites
Install Foundry:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```
### Installation
Clone the repository and install dependencies:
```bash
git clone https://github.com/eparreno1989/foundry-ecosystem-Token-Suite.git
cd foundry-ecosystem-Token-Suite
forge install
```
### Run Unit Tests
Execute the comprehensive test suite with verbose traces:
```bash
forge test -vvv
```
### Run Coverage Analysis
```bash
forge coverage
```

---

## 🔐 Security & Testing Strategy
- Access Control: Restricted admin capabilities using OpenZeppelin's Ownable.

- Safe Transfers: Enforced receiver interface checks (IERC721Receiver, IERC1155Receiver).

- Boundary Checks: Rigorous revert validation on unauthorized minting, double-minting of unique items, and allowance limits.

--- 

## 👨‍💻 Author

**Erick**  
*Computer Engineer & Web3 Smart Contract Developer*

* **Role:** Computer Engineer / Web3 Engineer
* **Core Focus:** EVM Smart Contract Development, Security Auditing Standards, & DeFi Protocols
* **Tech Stack:** Solidity, Foundry (Forge, Cast, Anvil), OpenZeppelin, Hardhat, JavaScript/TypeScript
* **GitHub:** [@eparreno1989](https://github.com/eparreno1989)
* **LinkedIn:** [Erick Parreño](https://linkedin.com/in/erick-parreño-a3a8271bb)

---

> *Project built as part of a Web3 Smart Contract Development & Security Engineering Portfolio.*

