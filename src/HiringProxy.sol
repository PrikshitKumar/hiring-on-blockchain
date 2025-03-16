// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

contract HiringProxy is TransparentUpgradeableProxy {
    event ContractUpgraded(address newImplementation); 

    constructor(address _logic, address _admin, bytes memory _data)
        TransparentUpgradeableProxy(_logic, _admin, _data)
    {}

    function upgradeTo(address newImplementation) external {
        ERC1967Utils.upgradeToAndCall(newImplementation, new bytes(0));
        emit ContractUpgraded(newImplementation);
    }

    receive() external payable {} 
}
