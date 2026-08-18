// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {Test} from "forge-std/Test.sol";
import {DeveloperPass} from "../src/ERC721/DeveloperPass.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title DeveloperPassTest - Unit Test Suite for DeveloperPass ERC-721 Contract
/// @author Web3 Engineering Team
/// @notice Verifies initial contract deployment state, safe minting with IPFS URI, and access control.
/// @dev Inherits from Forge Standard Test library (`Test.sol`).
contract DeveloperPassTest is Test {
    /// @notice Instance of the DeveloperPass ERC-721 contract under test
    DeveloperPass public nft;

    /// @notice Test address representing the contract administrator / owner
    address public owner = makeAddr("owner");

    /// @notice Test address representing a regular non-owner user
    address public user1 = makeAddr("user1");

    /// @notice Sample IPFS metadata URI used for test minting operations
    string public sampleURI = "ipfs://bafkreid2m7b5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi";

    /// @notice Setup function executed before each test method in the suite.
    /// @dev Deploys a fresh instance of DeveloperPass as the `owner` address.
    function setUp() public {
        vm.prank(owner);
        nft = new DeveloperPass("Dev Pass", "DEVPASS", owner);
    }

    /// @notice Tests that the contract initializes with correct metadata, owner, and zero total supply.
    function test_InitialState() public view {
        assertEq(nft.name(), "Dev Pass");
        assertEq(nft.symbol(), "DEVPASS");
        assertEq(nft.owner(), owner);
        assertEq(nft.totalMinted(), 0);
    }

    /// @notice Tests that the contract owner can successfully mint an NFT with custom IPFS metadata URI.
    /// @dev Verifies token ID generation, recipient balance, ownership assignment, and URI storage.
    function test_OwnerCanMintWithURI() public {
        vm.prank(owner);
        uint256 tokenId = nft.safeMint(user1, sampleURI);

        assertEq(tokenId, 1);
        assertEq(nft.ownerOf(1), user1);
        assertEq(nft.balanceOf(user1), 1);
        assertEq(nft.tokenURI(1), sampleURI);
        assertEq(nft.totalMinted(), 1);
    }

    /// @notice Tests that non-owner accounts are prevented from minting tokens.
    /// @dev Expects a revert with OpenZeppelin's `OwnableUnauthorizedAccount` custom error selector.
    function testRevert_NonOwnerCannotMint() public {
        vm.startPrank(user1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                user1
            )
        );
        nft.safeMint(user1, sampleURI);
        vm.stopPrank();
    }
}