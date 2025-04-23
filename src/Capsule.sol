// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721EnumerableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Capsule is ERC721EnumerableUpgradeable, OwnableUpgradeable {
    event Mint(address user, uint256 tokenId);
    event BatchMint(address user, uint256 startTokenId, uint256 amount);
    event WithdrawFunds();

    uint256 public constant MINT_TIME_PERIOD = 1 days;

    string private _tokenURI;
    uint256 private _nextTokenId;

    uint256 public immutable startTime;
    mapping(address => bool) public hasMinted;

    constructor(uint256 _startTime, string memory _uri) {
        startTime = _startTime;
        _tokenURI = _uri;
    }

    function initialize(
        string memory _name,
        string memory _symbol
    ) external initializer {
        __ERC721_init(_name, _symbol);
        __Ownable_init(msg.sender);
    }

    function tokenURI(uint256) public view override returns (string memory) {
        return _tokenURI;
    }

    function getNextTokenId() external view returns (uint256) {
        return _nextTokenId;
    }

    // mint for all users
    function mint() external {
        require(
            block.timestamp >= startTime &&
                block.timestamp <= startTime + MINT_TIME_PERIOD,
            "Invalid mint time"
        );
        require(hasMinted[msg.sender] == false, "Already minted");
        hasMinted[msg.sender] = true;
        emit Mint(msg.sender, _nextTokenId);
        _safeMint(msg.sender, _nextTokenId++);
    }

    // batch mint for admin
    function adminMint(uint256 _amount) external onlyOwner {
        require(
            block.timestamp >= startTime &&
                block.timestamp <= startTime + MINT_TIME_PERIOD,
            "Invalid mint time"
        );
        emit BatchMint(msg.sender, _nextTokenId, _amount);
        for (uint256 i = 0; i < _amount; i++) {
            _safeMint(msg.sender, _nextTokenId++);
        }
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
