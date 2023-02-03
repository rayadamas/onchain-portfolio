// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {IERC721PressLogic} from "../../../src/token/ERC721/interfaces/IERC721PressLogic.sol";

contract MockLogic is IERC721PressLogic {
    
    bytes storageTest;

    function initializeWithData(bytes memory initData) external {
        storageTest = initData;
    }

    function canUpdateConfig(address targetPress, address updateCaller) external view returns (bool) {}

    function canMint(address targetPress, uint64 mintQuantity, address mintCaller) external view returns (bool) {
        return true;
    }

    function canEditMetadata(address targetPress, address editCaller) external view returns (bool) {}

    function canWithdraw(address targetPress, address withdrawCaller) external view returns (bool) {}

    function canBurn(address targetPress, uint256 tokenId, address burnCaller) external view returns (bool) {}

    function canUpgrade(address targetPress, address upgradeCaller) external view returns (bool) {}

    function canTransfer(address targetPress, address transferCaller) external view returns (bool) {}

    function totalMintPrice(address targetPress, uint64 mintQuantity, address mintCaller)
        external
        view
        returns (uint256)
    {}

    function isInitialized(address targetPress) external view returns (bool) {}

    function maxSupply() external view returns (uint64) {}
}
