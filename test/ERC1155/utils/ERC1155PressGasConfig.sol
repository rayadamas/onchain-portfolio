// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {ERC1155Press} from "../../../src/token/ERC1155/ERC1155Press.sol";
import {ERC1155PressProxy} from "../../../src/token/ERC1155/core/proxy/ERC1155PressProxy.sol";

import {ERC1155EditionContractLogic} from "../../../src/token/ERC1155/strategies/editions/logic/ERC1155EditionContractLogic.sol";
import {ERC1155EditionTokenLogic} from "../../../src/token/ERC1155/strategies/editions/logic/ERC1155EditionTokenLogic.sol";

import {ERC1155EditionRenderer} from "../../../src/token/ERC1155/strategies/editions/metadata/ERC1155EditionRenderer.sol";


contract ERC1155PressGasConfig is Test {
    // test roles
    address public constant INITIAL_OWNER = address(0x01);
    address public constant FUNDS_RECIPIENT = address(0x02);
    address public constant ADMIN = address(0x03);
    address public constant MINTER = address(0x04);
    address public constant RANDOM_WALLET = address(0x05);
    // test contract initialize inptus
    string public contractName = "ERC1155Press Test";
    string public contractSymbol = "T1155";

    // contract level logic inputs
    address public contractAdminInit = INITIAL_OWNER;
    uint256 public mintNewPriceInit = 0.01 ether;
    bytes public contractLogicInit = abi.encode(contractAdminInit, mintNewPriceInit);
    // token level logic inputs
    address public tokenAdminInit = INITIAL_OWNER;
    uint256 public startTimePast = 0;
    uint256 public startTimeFuture = 32506345355; // year 3000
    uint256 public mintExistingPriceInit = 0.001 ether;
    bytes public tokenLogicInit = abi.encode(tokenAdminInit, startTimePast, mintExistingPriceInit);
    // token level inputs
    string public exampleString1 = "exampleString1";
    string public exampleString2 = "exampleString2";
    bytes public tokenRendererInit = abi.encode(exampleString1);

    // set up base impl
    ERC1155Press erc1155Press;
    address public erc1155PressImpl;

    // Deploy basic contract and token level logic
    ERC1155EditionContractLogic public contractLogic = new ERC1155EditionContractLogic();
    ERC1155EditionTokenLogic public tokenLogic = new ERC1155EditionTokenLogic();

    // Deploy basic renderer contract
    ERC1155EditionRenderer public editionRenderer = new ERC1155EditionRenderer();

    // Set up called before each test
    function setUp() public {
        // Deploy an ERC1155Press instance
        erc1155PressImpl = address(new ERC1155Press());

        // Create a proxy for that instance
        address payable pressProxy = payable(address(new ERC1155PressProxy(erc1155PressImpl, "")));

        erc1155Press = ERC1155Press(pressProxy);

        // initialize erc1155 contract
        erc1155Press.initialize({
            _name: contractName,
            _symbol: contractSymbol,
            _initialOwner: INITIAL_OWNER,
            _contractLogic: contractLogic,
            _contractLogicInit: contractLogicInit
        });

        // mint new tokens to be used in mintExisting + batchMintExisting calls
        vm.startPrank(INITIAL_OWNER);
        vm.deal(INITIAL_OWNER, 10 ether);
        address[] memory mintNewRecipients = new address[](1);
        mintNewRecipients[0] = ADMIN;
        uint256 quantity = 1;
        address payable fundsRecipient = payable(ADMIN);
        uint16 royaltyBPS = 10_00; // 10%
        address payable primarySaleFeeRecipient = payable(MINTER);
        uint16 primarySaleFeeBPS = 5_00; // 5%
        bool soulbound = false;
        erc1155Press.mintNew{
            value: 0.01 ether 
        }(
            mintNewRecipients,
            quantity,
            tokenLogic,
            tokenLogicInit,
            editionRenderer,
            tokenRendererInit,
            fundsRecipient,
            royaltyBPS,
            primarySaleFeeRecipient,
            primarySaleFeeBPS,
            soulbound
        );
        erc1155Press.mintNew{
            value: 0.01 ether 
        }(
            mintNewRecipients,
            quantity,
            tokenLogic,
            tokenLogicInit,
            editionRenderer,
            tokenRendererInit,
            fundsRecipient,
            royaltyBPS,
            primarySaleFeeRecipient,
            primarySaleFeeBPS,
            soulbound
        );        
        vm.stopPrank();
    }
}