// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title DeveloperPass - ERC-721 Non-Fungible Token with IPFS Metadata URI Storage
/// @author Web3 Engineering Team
/// @notice Non-Fungible Token (NFT) implementation representing developer access passes.
/// @dev Extends OpenZeppelin's ERC721URIStorage and Ownable contracts.
contract DeveloperPass is ERC721URIStorage, Ownable {
    /// @dev Internal state counter tracking the total number of minted token IDs.
    uint256 private _nextTokenId;

    /// @notice Emitted whenever a new Developer Pass NFT is successfully minted.
    /// @param recipient Address receiving the newly minted NFT.
    /// @param tokenId The unique identifier assigned to the minted NFT.
    /// @param tokenURI The IPFS URI pointing to the token's JSON metadata file.
    event NFTMinted(address indexed recipient, uint256 indexed tokenId, string tokenURI);

    /// @notice Initializes the DeveloperPass contract setting token name, symbol, and initial owner.
    /// @param name Human-readable name of the NFT collection (e.g., "Developer Pass").
    /// @param symbol Ticker symbol of the NFT collection (e.g., "DEVPASS").
    /// @param initialOwner Address receiving administrative ownership privileges upon deployment.
    constructor(
        string memory name,
        string memory symbol,
        address initialOwner
    ) ERC721(name, symbol) Ownable(initialOwner) {}

    /// @notice Safely mints a new NFT and assigns its IPFS metadata URI.
    /// @dev Utilizes pre-increment operator on `_nextTokenId` and enforces `onlyOwner` access control.
    /// @param recipient Wallet address that will receive ownership of the newly minted NFT.
    /// @param uri IPFS metadata string (e.g., "ipfs://bafybeig.../metadata.json").
    /// @return tokenId The unique identifier generated for the newly minted NFT.
    function safeMint(address recipient, string memory uri) public onlyOwner returns (uint256) {
        uint256 tokenId = ++_nextTokenId;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, uri);

        emit NFTMinted(recipient, tokenId, uri);
        return tokenId;
    }

    /// @notice Returns the total quantity of tokens minted by this contract to date.
    /// @dev Reads the current value of the private state variable `_nextTokenId`.
    /// @return The total number of minted NFTs.
    function totalMinted() external view returns (uint256) {
        return _nextTokenId;
    }
}