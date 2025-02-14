// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract ImplementationV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable{
    uint256 internal number;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
        @dev Proxied Implementation contracts donot use constructors.
        All storage variables are tracked on the proxy contract.
        An initialization design pattern is used instead of the constructors
        @dev Recent updates to the OwnableUpgradeable library now require an argument to be passed to the __Ownable_init function.
     */
    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function setNumber(uint256 _number) external{
        number = _number;
    }

    function getNumber() external view returns(uint256){
        return number;
    }

    function version() external pure returns(uint256){
        return 2;
    }

    /**
        @dev Define logic who can authorize an upgrade within the protocol
     */
    function _authorizeUpgrade(address newImplementation) internal override {}
}
