pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {Capsule} from "../src/Capsule.sol";

contract CapsuleTest is Test {
    string public constant TOKEN_URI = "TOKEN_URI";

    Capsule public capsule;

    address public msgSender = address(1);
    address public admin = address(2);
    uint256 public startTime;

    function setUp() public virtual {
        // deploy mock OFT
        uint256 startTime = block.timestamp + 10 minutes;
        capsule = new Capsule(startTime);

        capsule.initialize(admin, "OnePiece Capsule", "OC", TOKEN_URI);

        assertEq(capsule.startTime(), startTime);
        assertEq(capsule.tokenURI(0), TOKEN_URI);
    }

    function test_MintProcess() public {
        vm.startPrank(msgSender);
        uint256 initialTokenId = capsule.getNextTokenId();

        assertEq(capsule.balanceOf(msgSender), 0);
        assertEq(capsule.hasMinted(msgSender), false);

        vm.expectRevert("Invalid mint time");
        capsule.mint();

        skip(10 minutes); // skip to start time
        vm.expectEmit();
        emit Capsule.Mint(msgSender, initialTokenId);
        capsule.mint();
        assertEq(capsule.balanceOf(msgSender), 1);
        assertEq(capsule.hasMinted(msgSender), true);

        vm.expectRevert("Already minted");
        capsule.mint();
    }

    function test_AdminMintProcess() public {
        vm.startPrank(admin);
        uint256 initialTokenId = capsule.getNextTokenId();
        uint256 mintAmount = 100;

        assertEq(capsule.balanceOf(admin), 0);

        vm.expectRevert("Invalid mint time");
        capsule.adminMint(mintAmount);

        skip(10 minutes); // skip to start time
        vm.expectEmit();
        emit Capsule.BatchMint(admin, initialTokenId, mintAmount);
        capsule.adminMint(mintAmount);
        assertEq(capsule.balanceOf(admin), mintAmount);

        vm.expectEmit();
        emit Capsule.BatchMint(admin, initialTokenId + mintAmount, mintAmount);
        capsule.adminMint(mintAmount);
        assertEq(capsule.balanceOf(admin), mintAmount + mintAmount);
    }
}
