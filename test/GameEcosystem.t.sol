// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {Test} from "forge-std/Test.sol";
import {GameEcosystem} from "../src/ERC1155/GameEcosystem.sol";

/// @title GameEcosystemTest - Unit Test Suite for GameEcosystem ERC-1155 Contract
/// @author Web3 Engineering Team
/// @notice Tests item purchases, currency burning mechanics, URI resolution, and single-supply enforcement.
/// @dev Inherits from Forge Standard Test library (`Test.sol`).
contract GameEcosystemTest is Test {
    /// @notice Instance of the GameEcosystem ERC-1155 contract under test
    GameEcosystem public game;

    /// @notice Test address representing the admin / contract owner
    address public admin = makeAddr("admin");

    /// @notice Test address representing a standard player
    address public player = makeAddr("player");

    /// @notice Base IPFS URI string used for initializing token metadata paths
    string public baseURI = "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi/";

    /// @notice Setup function executed prior to running each unit test.
    /// @dev Deploys a fresh GameEcosystem instance as `admin` and pre-funds `player` with initial Gold Coins.
    function setUp() public {
        vm.prank(admin);
        game = new GameEcosystem(baseURI, admin);

        // Pre-fund player with 2,000 Gold Coins for crafting tests
        vm.prank(admin);
        game.mintGold(player, 2000);
    }

    /// @notice Verifies that the player receives correct starting balances after setup.
    function test_InitialBalances() public view {
        assertEq(game.balanceOf(player, game.GOLD_COIN()), 2000);
        assertEq(game.balanceOf(player, game.WOODEN_SHIELD()), 0);
    }

    /// @notice Tests purchasing fungible Wooden Shields by burning the required Gold Coin balance.
    /// @dev Verifies that 400 Gold Coins are burned (200 x 2) and 2 Wooden Shields are minted.
    function test_BuyWoodenShield() public {
        vm.prank(player);
        game.buyWoodenShield(2);

        assertEq(game.balanceOf(player, game.GOLD_COIN()), 1600);
        assertEq(game.balanceOf(player, game.WOODEN_SHIELD()), 2);
    }

    /// @notice Tests purchasing the unique Legendary Sword by burning Gold Coins.
    /// @dev Verifies that 1,000 Gold Coins are burned, Legendary Sword is minted, and `swordMinted` flag is set to true.
    function test_BuyLegendarySword() public {
        vm.prank(player);
        game.buyLegendarySword();

        assertEq(game.balanceOf(player, game.GOLD_COIN()), 1000);
        assertEq(game.balanceOf(player, game.LEGENDARY_SWORD()), 1);
        assertTrue(game.swordMinted());
    }

    /// @notice Tests single-supply restriction ensuring the Legendary Sword cannot be minted more than once.
    /// @dev Verifies transaction revert with "Legendary Sword already minted" error string on second attempt.
    function testRevert_CannotMintSwordTwice() public {
        // First player successfully purchases the unique sword
        vm.prank(player);
        game.buyLegendarySword();

        // Admin pre-funds a second player
        address player2 = makeAddr("player2");
        vm.prank(admin);
        game.mintGold(player2, 2000);

        // Second player attempt must revert
        vm.prank(player2);
        vm.expectRevert("Legendary Sword already minted");
        game.buyLegendarySword();
    }
}