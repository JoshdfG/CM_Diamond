// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LibCertificateFactory {
    bytes32 constant STORAGE_POSITION =
        keccak256("certificate.factory.storage");

    struct Storage {
        address admin;
    }

    function diamondStorage() internal pure returns (Storage storage ds) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function setAdmin(address _admin) internal {
        diamondStorage().admin = _admin;
    }

    function getAdmin() internal view returns (address) {
        return diamondStorage().admin;
    }
}
