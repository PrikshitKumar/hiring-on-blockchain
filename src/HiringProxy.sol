// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract HiringProcessProxy is TransparentUpgradeableProxy {
    event ContractUpgraded(address newImplementation); 

    modifier onlyProxyAdmin() {
        require(msg.sender == _proxyAdmin(), "Not admin");
        _;
    }

    constructor(address _logic, address _admin, bytes memory _data)
        TransparentUpgradeableProxy(_logic, _admin, _data)
    {}

    function upgradeTo(address newImplementation) external onlyProxyAdmin {
        _upgradeTo(newImplementation);
        emit ContractUpgraded(newImplementation);
    }

    function _proxyAdmin() internal view returns (address adm) {
        bytes32 slot = _ADMIN_SLOT;
        assembly {
            adm := sload(slot)
        }
    }
}
