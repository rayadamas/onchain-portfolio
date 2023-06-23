// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {IERC721PressRenderer} from "../../../../src/core/token/ERC721/interfaces/IERC721PressRenderer.sol";
import {ERC721Press} from "../../../../src/core/token/ERC721/ERC721Press.sol";

contract MockRenderer is IERC721PressRenderer { 

    // error caused by initialization not being called by Press database contract
    error UnauthorizedInitializer();

    mapping(address => bool) public pressInitializedInfo;

    function initializeWithData(address targetPress, bytes memory initData) external {

        if (msg.sender != address(ERC721Press(payable(targetPress)).getDatabase())) {
            revert UnauthorizedInitializer();
        }        

        require(initData.length > 0, "shouldnt equal zero");

        pressInitializedInfo[targetPress] = true;
    }

    function getTokenURI(address targetPress, uint256 tokenId) external view returns (string memory) {
        return "DEMO";
    }

    function getContractURI(address targetPress) external view returns (string memory) {
        return "DEMO";
    }
}