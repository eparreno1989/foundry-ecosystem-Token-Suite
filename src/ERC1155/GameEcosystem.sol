// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/// @title GameEcosystem - ERC-1155 Multi-Token Game Items and Currency Manager
/// @author Web3 Engineering Team
/// @notice Multi-token contract managing fungible in-game currency and non-fungible items.
/// @dev Extends OpenZeppelin's ERC1155 and Ownable modules. Utilizes OpenZeppelin Strings library for URI resolution.
contract GameEcosystem is ERC1155, Ownable {
    using Strings for uint256;

    /// @notice Item Identifier for fungible gold coins
    uint256 public constant GOLD_COIN = 0;

    /// @notice Item Identifier for the unique non-fungible legendary sword
    uint256 public constant LEGENDARY_SWORD = 1;

    /// @notice Item Identifier for fungible wooden shields
    uint256 public constant WOODEN_SHIELD = 2;

    /// @notice Price in Gold Coins required to purchase/craft a Legendary Sword
    uint256 public constant SWORD_PRICE = 1000;

    /// @notice Price in Gold Coins required to purchase/craft a Wooden Shield
    uint256 public constant SHIELD_PRICE = 200;

    /// @notice Global state flag tracking whether the unique Legendary Sword has been minted
    bool public swordMinted;

    /// @notice Emitted whenever a player purchases/crafts an item using Gold Coins.
    /// @param player Address of the player executing the purchase.
    /// @param itemId Identifier of the item acquired.
    /// @param amount Quantity of items minted to the player.
    event ItemPurchased(address indexed player, uint256 indexed itemId, uint256 amount);

    /// @notice Initializes the GameEcosystem contract with a base IPFS URI and contract owner.
    /// @param baseUri The base IPFS URI pointing to item metadata storage.
    /// @param initialOwner Address receiving ownership administrative privileges upon deployment.
    constructor(
        string memory baseUri,
        address initialOwner
    ) ERC1155(baseUri) Ownable(initialOwner) {}

    /// @notice Mints Gold Coins to a target address.
    /// @dev Restricted function invokable exclusively by the contract owner (`onlyOwner`).
    /// @param to Address receiving the minted gold coins.
    /// @param amount Quantity of gold coins to mint.
    function mintGold(address to, uint256 amount) external onlyOwner {
        _mint(to, GOLD_COIN, amount, "");
    }

    /// @notice Allows players to burn Gold Coins in exchange for Wooden Shields.
    /// @dev Burns `SHIELD_PRICE * amount` of `GOLD_COIN` from caller's balance before minting.
    /// @param amount Quantity of wooden shields to purchase.
    function buyWoodenShield(uint256 amount) external {
        uint256 totalCost = SHIELD_PRICE * amount;
        
        _burn(msg.sender, GOLD_COIN, totalCost);
        _mint(msg.sender, WOODEN_SHIELD, amount, "");

        emit ItemPurchased(msg.sender, WOODEN_SHIELD, amount);
    }

    /// @notice Allows players to burn Gold Coins to acquire the unique Legendary Sword.
    /// @dev Enforces strict single-supply policy (`swordMinted`) and burns `SWORD_PRICE` gold coins.
    function buyLegendarySword() external {
        require(!swordMinted, "Legendary Sword already minted");
        
        swordMinted = true;
        _burn(msg.sender, GOLD_COIN, SWORD_PRICE);
        _mint(msg.sender, LEGENDARY_SWORD, 1, "");

        emit ItemPurchased(msg.sender, LEGENDARY_SWORD, 1);
    }

    /// @notice Overrides the standard ERC-1155 uri function to concatenate token IDs with `.json` extension.
    /// @param tokenId The identifier of the token whose URI is queried.
    /// @return Complete metadata URI string (e.g., "ipfs://<CID>/1.json").
    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(super.uri(tokenId), tokenId.toString(), ".json"));
    }
}