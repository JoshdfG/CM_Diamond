// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";

import {IDiamondCut, FacetCut, FacetCutAction} from "../contracts/interfaces/IDiamondCut.sol";

import {organisationFacet} from "../contracts/facets/OrganisationFacet.sol";
import {organisationFactoryFacet} from "../contracts/facets/OrganisationFactoryFacet.sol";

contract ReplaceAccessControlFacet is Script {
    AccessControlFacet accessControlFacet;

    modifier broadcast() {
        vm.startBroadcast();
        _;
        vm.stopBroadcast();
    }

    function run(address hostItAddress) external broadcast {
        organisationFacet = new organisationFacet();

        FacetCut[] memory cut = new FacetCut[](1);

        bytes4[] memory accessControlSelectors = new bytes4[](1);
        accessControlSelectors[0] = AccessControlFacet.getRoleAdmin.selector;
        // accessControlSelectors[1] = AccessControlFacet.grantRole.selector;
        // accessControlSelectors[2] = AccessControlFacet.hasRole.selector;
        // accessControlSelectors[3] = AccessControlFacet.renounceRole.selector;
        // accessControlSelectors[4] = AccessControlFacet.revokeRole.selector;
        // accessControlSelectors[5] = AccessControlFacet.setRoleAdmin.selector;

        cut[0] = FacetCut({
            facetAddress: address(accessControlFacet),
            action: FacetCutAction.add,
            functionSelectors: accessControlSelectors
        });

        IDiamondCut(hostItAddress).diamondCut(cut, address(0), "");
    }
}
