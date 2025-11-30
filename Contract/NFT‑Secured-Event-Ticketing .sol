// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
 * NFT-Secured Event Ticketing
 * Simple ERC721-style NFT Ticket Contract
 */

contract Project {
    string public name = "NFT-Secured Event Ticket";
    string public symbol = "TICKET";

    address public owner;
    uint256 private _tokenIds;

    // --- MAPPINGS ---
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;

    // --- EVENTS ---
    event TicketMinted(address indexed to, uint256 tokenId);
    event TicketTransferred(address indexed from, address indexed to, uint256 tokenId);

    // --- MODIFIERS ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action");
        _;
    }

    modifier onlyTicketOwner(uint256 tokenId) {
        require(_owners[tokenId] == msg.sender, "You do not own this ticket");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // ------------------------------------------------------
    // 1. CREATE TICKET (Minting)
    // ------------------------------------------------------
    function createTicket(address to) external onlyOwner returns (uint256) {
        require(to != address(0), "Invalid address");

        _tokenIds += 1;
        uint256 newTicketId = _tokenIds;

        _owners[newTicketId] = to;
        _balances[to] += 1;

        emit TicketMinted(to, newTicketId);
        return newTicketId;
    }

    // ------------------------------------------------------
    // 2. TRANSFER TICKET
    // ------------------------------------------------------
    function transferTicket(address to, uint256 tokenId) 
        external 
        onlyTicketOwner(tokenId) 
    {
        require(to != address(0), "Cannot transfer to zero address");

        address from = msg.sender;

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit TicketTransferred(from, to, tokenId);
    }

    // ------------------------------------------------------
    // 3. VERIFY OWNERSHIP
    // ------------------------------------------------------
    function verifyOwnership(address user, uint256 tokenId) 
        external 
        view 
        returns (bool) 
    {
        return _owners[tokenId] == user;
    }

    // Optional balance lookup
    function balanceOf(address user) external view returns (uint256) {
        return _balances[user];
    }

    // Optional owner lookup
    function ownerOf(uint256 tokenId) external view returns (address) {
        return _owners[tokenId];
    }
}

