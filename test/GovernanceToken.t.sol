// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {Test} from "forge-std/Test.sol";
import {GovernanceToken} from "../src/ERC20/GovernanceToken.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract GovernanceTokenTest is Test {
    GovernanceToken public token;
    string public name;
    string public symbol;
    address public initialOwner;
    address public user1;
    uint256 public initialSupply;

    function setUp() public {
        name = "MyToken";
        symbol = "MYT";
        initialOwner = makeAddr("owner");
        user1 = makeAddr("user1");
        initialSupply = 1000e18;

        vm.prank(initialOwner);
        token = new GovernanceToken(name, symbol, initialSupply, initialOwner);
    }

    function test_InitialSupplyAndOwner() public view {
        uint256 initialBalance = token.balanceOf(initialOwner);
        assertEq(initialBalance, initialSupply);
        assertEq(token.owner(), initialOwner);
    }

    function test_OwnerCanMint(uint256 _amount) public {
        // Acotamos el valor entre 1 y 1.000.000 de tokens para evitar overflow en el fuzz test
        uint256 amount = bound(_amount, 1, 1_000_000e18);

        vm.prank(initialOwner);
        token.mint(initialOwner, amount);

        uint256 currentBalance = token.balanceOf(initialOwner);
        assertEq(currentBalance, initialSupply + amount);
    }

    function testRevert_NonOwnerCannotMint() public {
        uint256 mintAmount = 500e18;

        vm.startPrank(user1);
        // Capturamos el Custom Error de OpenZeppelin especificando la direccion que falla (user1)
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                user1
            )
        );
        token.mint(user1, mintAmount);
        vm.stopPrank();
    }

    function test_UserCanBurn() public {
        uint256 burnAmount = 200e18;

        // 1. Verificamos balance inicial del owner antes de quemar
        uint256 startingBalance = token.balanceOf(initialOwner);
        uint256 startingTotalSupply = token.totalSupply();

        // 2. El owner quema sus propios tokens (ERC20Burnable provee la funcion burn)
        vm.prank(initialOwner);
        token.burn(burnAmount);

        // 3. Comprobamos reduccion de saldo individual y de suministro global
        assertEq(token.balanceOf(initialOwner), startingBalance - burnAmount);
        assertEq(token.totalSupply(), startingTotalSupply - burnAmount);
    }

    /// @notice Tests that transfers exceeding the approved allowance revert with `ERC20InsufficientAllowance`.
    /// @dev Verifies OpenZeppelin ERC20 protection when a spender attempts to transfer more tokens than permitted.
    function testRevert_TransferFromExceedsAllowance() public {
        address tokenOwner = makeAddr("tokenOwner");
        address spender = makeAddr("spender");
        address recipient = makeAddr("recipient");

        // 1. Mint initial tokens to tokenOwner
        vm.prank(initialOwner);
        token.mint(tokenOwner, 1000e18);

        // 2. tokenOwner approves spender to spend 100 tokens
        vm.prank(tokenOwner);
        token.approve(spender, 100e18);

        // 3. Spender attempts to transfer 150 tokens (exceeds the 100 token allowance)
        vm.startPrank(spender);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                spender,   // Address attempting the spending
                100e18,    // Current allowance available
                150e18     // Needed / requested allowance
            )
        );
        token.transferFrom(tokenOwner, recipient, 150e18);
        vm.stopPrank();
    }
}