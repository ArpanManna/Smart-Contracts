//SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {ImplementationV1} from "../src/ImplementationV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
/* solhint-disable no-console*/
import {console2} from "forge-std/console2.sol";

contract DeployImplementation is Script {
    function run() external returns (address) {
        address proxy = deployImplementationV1();
        return proxy;
    }

    function deployImplementationV1() public returns (address) {
        vm.startBroadcast();
        // deploy Implementation contract
        ImplementationV1 implementation = new ImplementationV1(); // Implementation
        assert(address(implementation) != address(0));
        // deploy proxy contract and at the same time initialize the proxy contract (calls the initialize function)
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), "");
        ImplementationV1(address(proxy)).initialize();
        assert(address(proxy) != address(0));
        vm.stopBroadcast();
        console2.log(
            "Implementation address: %s",
            address(implementation)
        );
        console2.log("Proxy address: %s", address(proxy));
        return address(proxy);
    }
}
