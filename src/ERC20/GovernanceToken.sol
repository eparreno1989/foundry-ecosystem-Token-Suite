// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title GovernanceToken - ERC-20 Fungible Token with Minting and Burning Capabilities
/// @author Web3 Engineering Team
/// @notice Custom ERC-20 token implementation serving as a core utility and governance asset.
/// @dev Extends OpenZeppelin's ERC20, ERC20Burnable, and Ownable modules.
contract GovernanceToken is ERC20, ERC20Burnable, Ownable {
    /// @notice Custom error emitted when attempting to mint to the zero address.
    error InvalidRecipientAddress();

    /// @notice Emitted whenever new tokens are minted to an account.
    /// @param to Address receiving the newly minted tokens.
    /// @param amount Quantity of tokens minted (in wei).
    event TokensMinted(address indexed to, uint256 amount);

    /// @notice Initializes the Governance Token contract setting name, symbol, initial supply, and owner.
    /// @dev Mints the `initialSupply` directly to the `initialOwner` address upon deployment.
    /// @param name The human-readable name of the token (e.g., "Governance Token").
    /// @param symbol The ticker symbol of the token (e.g., "GOV").
    /// @param initialSupply The total initial token supply minted at creation (in wei).
    /// @param initialOwner Address receiving initial supply and ownership administrative privileges.
    constructor(string memory name, string memory symbol, uint256 initialSupply, address initialOwner)
        ERC20(name, symbol)
        Ownable(initialOwner)
    {
        if (initialSupply > 0) {
            _mint(initialOwner, initialSupply);
            emit TokensMinted(initialOwner, initialSupply);
        }
    }

    /// @notice Mints new tokens and assigns them to the specified recipient.
    /// @dev Restricted function that can only be invoked by the contract owner (`onlyOwner`).
    /// @param to Address that will receive the minted tokens.
    /// @param amount Quantity of tokens to mint (in wei).
    function mint(address to, uint256 amount) external onlyOwner {
        if (to == address(0)) {
            revert InvalidRecipientAddress();
        }
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }
}
