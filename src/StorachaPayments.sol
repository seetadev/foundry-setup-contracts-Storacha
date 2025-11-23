// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice StoragePayments: accept ERC20 deposits (USDC, FST, etc.) and emit Deposit events for backend crediting.
/// - Users must `approve` this contract for token transfer before calling `deposit`.
/// - Back-end listener watches Deposit event, validates tx (confirmations) and credits user.
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";

contract StoragePayments is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    /// @notice treasury address where owner can withdraw funds
    address public treasury;

    /// @notice whether deposits are paused
    bool public paused;

    /// @notice mapping of allowed tokens (token address => enabled)
    mapping(address => bool) public isSupportedToken;

    /// @notice optional mapping of token decimals (for reference; not used for arithmetic here)
    mapping(address => uint8) public tokenDecimals;

    /// @dev indexed fields help backend filtering
    event Deposit(
        address indexed payer,
        address indexed token,
        uint256 amount,        // raw token units (use token decimals)
        uint256 credits,       // optional client-suggested credits (server must validate)
        string memo,           // freeform memo (e.g., preview url like /mnt/data/page.tsx)
        uint256 timestamp,
        bytes32 txRef
    );

    event Withdraw(address indexed to, address indexed token, uint256 amount);
    event SupportedTokenAdded(address indexed token, uint8 decimals);
    event SupportedTokenRemoved(address indexed token);
    event TreasuryChanged(address indexed newTreasury);
    event Paused();
    event Unpaused();

    modifier notPaused() {
        require(!paused, "deposits paused");
        _;
    }

    constructor(address _treasury) Ownable(msg.sender) {
        require(_treasury != address(0), "zero treasury");
        treasury = _treasury;
    }

    /// -----------------------------------------------------------------------
    /// Admin
    /// -----------------------------------------------------------------------
    /// @notice Add a supported token (owner only)
    /// @param token ERC20 address
    /// @param decimals token decimals (for bookkeeping)
    function addSupportedToken(address token, uint8 decimals) external onlyOwner {
        require(token != address(0), "zero token");
        isSupportedToken[token] = true;
        tokenDecimals[token] = decimals;
        emit SupportedTokenAdded(token, decimals);
    }

    /// @notice Remove supported token (owner only)
    function removeSupportedToken(address token) external onlyOwner {
        isSupportedToken[token] = false;
        tokenDecimals[token] = 0;
        emit SupportedTokenRemoved(token);
    }

    /// @notice Set treasury address (owner only)
    function setTreasury(address _treasury) external onlyOwner {
        require(_treasury != address(0), "zero treasury");
        treasury = _treasury;
        emit TreasuryChanged(_treasury);
    }

    /// @notice Pause deposits (owner only)
    function pause() external onlyOwner {
        paused = true;
        emit Paused();
    }

    /// @notice Unpause deposits (owner only)
    function unpause() external onlyOwner {
        paused = false;
        emit Unpaused();
    }

    /// -----------------------------------------------------------------------
    /// Deposits
    /// -----------------------------------------------------------------------
    /// @notice Deposit tokens to this contract. Caller must first `approve` this contract for `amount`.
    /// @param token ERC20 token address (must be supported)
    /// @param amount raw token amount (in token units — e.g., USDC 6 decimals)
    /// @param credits optional credits numeric value (off-chain server must validate)
    /// @param memo optional memo (use e.g. preview file path `/mnt/data/page.tsx`)
    function deposit(address token, uint256 amount, uint256 credits, string calldata memo)
        external
        nonReentrant
        notPaused
    {
        require(amount > 0, "amount>0");
        require(isSupportedToken[token], "token-not-supported");

        // Transfer tokens from payer to this contract (must be approved)
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        // emit Deposit for backend consumption. txRef is convenience id for dedupe
        bytes32 txRef = keccak256(abi.encodePacked(msg.sender, token, amount, block.timestamp));
        emit Deposit(msg.sender, token, amount, credits, memo, block.timestamp, txRef);
    }

    /// @notice Convenience: deposit and immediately forward to treasury (owner config). Useful if you don't want to keep balances in contract.
    /// BEWARE: forwarding has gas/transfer semantics — this still emits Deposit (for backend).
    function depositAndForward(address token, uint256 amount, uint256 credits, string calldata memo)
        external
        nonReentrant
        notPaused
    {
        require(amount > 0, "amount>0");
        require(isSupportedToken[token], "token-not-supported");
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        // Immediately forward to treasury (owner-controlled)
        IERC20(token).safeTransfer(treasury, amount);

        bytes32 txRef = keccak256(abi.encodePacked(msg.sender, token, amount, block.timestamp, "forward"));
        emit Deposit(msg.sender, token, amount, credits, memo, block.timestamp, txRef);
    }

    /// -----------------------------------------------------------------------
    /// Withdrawals (owner)
    /// -----------------------------------------------------------------------
    /// @notice Owner can withdraw tokens to a destination (treasury or other)
    function withdraw(address token, address to, uint256 amount) external onlyOwner nonReentrant {
        require(to != address(0), "zero dest");
        IERC20(token).safeTransfer(to, amount);
        emit Withdraw(to, token, amount);
    }

    /// -----------------------------------------------------------------------
    /// View helpers
    /// -----------------------------------------------------------------------
    function isTokenSupported(address token) external view returns (bool) {
        return isSupportedToken[token];
    }
}
