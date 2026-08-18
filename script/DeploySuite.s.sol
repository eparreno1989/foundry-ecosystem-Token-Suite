// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {Script, console} from "forge-std/Script.sol";
import {GovernanceToken} from "../src/ERC20/GovernanceToken.sol";
import {DeveloperPass} from "../src/ERC721/DeveloperPass.sol";
import {GameEcosystem} from "../src/ERC1155/GameEcosystem.sol";

/// @title DeploySuite - Deployment Script for Token Suite
/// @author Web3 Engineering Team
/// @notice Automated Foundry script to deploy ERC-20, ERC-721, and ERC-1155 token contracts.
/// @dev Inherits from Forge Standard Script library to broadcast transactions to EVM networks.
contract DeploySuite is Script {
    /// @notice Instance of the deployed ERC-20 Governance Token contract
    GovernanceToken public governanceToken;

    /// @notice Instance of the deployed ERC-721 Developer Pass NFT contract
    DeveloperPass public developerPass;

    /// @notice Instance of the deployed ERC-1155 Multi-Token Game Ecosystem contract
    GameEcosystem public gameEcosystem;

    /// @notice Main execution entry point for the deployment script
    /// @dev Retrieves the deployer's private key, initiates state broadcasting, and deploys all 3 contracts
    function run() external {
        // Retrieve private key from environment variables or fallback to Default Anvil Account #0
        uint256 deployerPrivateKey =
            vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));

        address deployer = vm.addr(deployerPrivateKey);

        console.log("====================================================");
        console.log("Deploying Token Suite with account:", deployer);
        console.log("Account Balance:", deployer.balance);
        console.log("====================================================");

        // Begin transaction broadcasting to the target RPC network
        vm.startBroadcast(deployerPrivateKey);

        // -----------------------------------------------------------------
        // 1. ERC-20 Deployment: Governance Token
        // Parameters: Name, Symbol, Initial Supply (1,000,000 tokens), Owner
        // -----------------------------------------------------------------
        uint256 initialSupply = 1_000_000 * 10 ** 18;
        governanceToken = new GovernanceToken("Governance Token", "GOV", initialSupply, deployer);
        console.log("GovernanceToken (ERC-20) deployed at:", address(governanceToken));

        // -----------------------------------------------------------------
        // 2. ERC-721 Deployment: Developer Pass NFT
        // Parameters: Name, Symbol, Owner
        // -----------------------------------------------------------------
        developerPass = new DeveloperPass("Developer Pass", "DEVPASS", deployer);
        console.log("DeveloperPass (ERC-721) deployed at:", address(developerPass));

        // -----------------------------------------------------------------
        // 3. ERC-1155 Deployment: Multi-Token Game Ecosystem
        // Parameters: Base URI (IPFS storage), Owner
        // -----------------------------------------------------------------
        string memory baseUri = "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi/";
        gameEcosystem = new GameEcosystem(baseUri, deployer);
        console.log("GameEcosystem (ERC-1155) deployed at:", address(gameEcosystem));

        // Terminate transaction broadcasting
        vm.stopBroadcast();

        console.log("====================================================");
        console.log("SUCCESS: All 3 contracts deployed successfully!");
        console.log("====================================================");
    }
}
