// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {ILogic} from "../logic/ILogic.sol";

interface IERC721PressDatabase {  

    // ||||||||||||||||||||||||||||||||
    // ||| TYPES ||||||||||||||||||||||
    // ||||||||||||||||||||||||||||||||

    struct Settings {
        /// @notice timestamp that the database is frozen at (if never, frozen = 0)
        uint256 frozenAt;
        /// @notice price to store new data
        uint256 priceToStore;        
        /// @notice Address of the logic contract
        address logic;
        /// Stores virtual mapping array length parameters
        /// @notice Array total size (total size)
        uint40 numAdded;
        /// @notice Array active size = numAdded - numRemoved
        /// @dev Blank entries are retained within array
        uint40 numRemoved;
        /// @notice initialized uint. 0 = not initialized, 1 = initialized
        uint8 initialized;
        /// @notice If database is paused by the owner
        bool isPaused;
        /// @notice Address of the renderer contract
        address renderer;                
    }    

    // ||||||||||||||||||||||||||||||||
    // ||| FUNCTIONS ||||||||||||||||||
    // ||||||||||||||||||||||||||||||||
    
    // Basic Info
    /// @notice adf
    function name() external view returns (string memory);
    /// @notice adf
    function owner() external view returns (address);

    // Initialize functions
    /// @notice initializes database with arbitrary data
    function initializeWithData(bytes memory initData) external;    
    /// @notice updates database with arbitary data
    function storeData(bytes calldata data) external;

    // Access control functions
    /// @notice checks if a certain address can update the Settings struct on a given Press 
    function canUpdateSettings(address targetPress, address updateCaller) external view returns (bool);
    /// @notice checks if a certain address can access mint functionality for a given Press + quantity combination
    function canMint(address targetPress, uint64 mintQuantity, address mintCaller) external view returns (bool);
    /// @notice checks if a certain address can edit metadata post metadata initialization for a given Press
    function canEditMetadata(address targetPress, address editCaller) external view returns (bool);    
    /// @notice checks if a certain address can call the withdraw function for a given Press
    function canWithdraw(address targetPress, address withdrawCaller) external view returns (bool);    
    /// @notice checks if a certain address can call the burn function for a given Press
    function canBurn(address targetPress, uint256 tokenId, address burnCaller) external view returns (bool);       
    
    // Informative read functions
    /// @notice Getter for a single listing id
    function getListing(address targetPress, uint256 listingIndex) external view returns (bytes memory);
    /// @notice Getter for a all listings
    function getListings(address targetPress) external view returns (bytes[] memory activeListings);  
    /// @notice calculates total mintPrice based on mintCaller, mintQuantity, and targetPress
    function totalMintPrice(address targetPress, uint64 mintQuantity, address mintCaller) external view returns (uint256);    
    /// @notice checks if a given Press has been initialized
    function isInitialized(address targetPress) external view returns (bool);  

    // ||||||||||||||||||||||||||||||||
    // ||| EVENTS |||||||||||||||||||||
    // ||||||||||||||||||||||||||||||||

    /// @notice Event emitted when mint Settings updated
    /// @param press Press that initialized logic file
    /// @param mintPrice universal mint price for contract
    /// @param maxSupply Press maxSupply
    /// @param mintCapPerAddress Press mintCapPerAddress
    event SettingsUpdated(
        address indexed sender,
        address indexed press,
        uint256 mintPrice,
        uint64 maxSupply,
        uint64 mintCapPerAddress
    );

    /// @notice Emitted when a listing is added
    event ListingAdded(
        address indexed targetPress,
        address indexed user,
        bytes listing
    );

    /// @notice Emitted when a listing is removed
    event ListingRemoved(
        address indexed targetPress,
        address indexed user,
        bytes listing
    );

    /// @notice A new logic contract is set
    event SetLogic(
        address indexed targetPress,
        ILogic logic
    );

    /// @notice Database Pause has been udpated.
    event DatabasePauseUpdated(
        address indexed targetPress,
        address indexed pauser,
        bool isPaused
    );

    /// @notice Sort order has been updated
    event UpdatedSortOrder(
        address indexed targetPress,
        uint256[] ids,
        int32[] sorts,
        address updatedBy
    );

    /// @notice This contract is scheduled to be frozen
    event ScheduledFreeze(address indexed targetPress, uint256 timestamp);       

    // ||||||||||||||||||||||||||||||||
    // ||| ERRORS |||||||||||||||||||||
    // ||||||||||||||||||||||||||||||||

    // Access errors
    /// @notice Address does not have admin role
    error Not_Admin();
    /// @notice msg.sender does not have pause access for given Press
    error No_Pause_Access();
    /// @notice msg.sender does not have freeze access for given Press
    error No_Freeze_Access();
    /// @notice msg.sender does not have sort order access for given Press
    error No_SortOrder_Access();
    /// @notice Access not allowed by given user
    error ACCESS_NOT_ALLOWED();

    // Constraint/invalid/failure errors
    /// @notice Target Press has not been initialized
    error Press_Not_Initialized();
    /// @notice Cannot set address to the zero address
    error Cannot_Set_Zero_Address();
    /// @notice Data received by logic contract is not correct length
    error Invalid_Input_Data_Length();    
    /// @notice Cannot check results for given mint params
    error Invalid_Mint_Settings();
    /// @notice Protects maxSupply from breaking when swapping in new logic
    error Cannot_Set_MaxSupply_Below_TotalMinted();
    /// @notice Array input lengths don't match for access control updates
    error Invalid_Input_Length();
    /// @notice Role value is not available
    error Invalid_Role();
    /// @notice Action is unable to complete because the database is paused.
    error DATABASE_PAUSED();
    /// @notice The pause state needs to be toggled and cannot be set to it's current value.
    error CANNOT_SET_SAME_PAUSED_STATE();
    /// @notice Error attempting to update the database after it has been frozen
    error DATABASE_FROZEN();
    /// @notice attempt to get owner of an unowned / burned token
    error TOKEN_HAS_NO_OWNER();    
}