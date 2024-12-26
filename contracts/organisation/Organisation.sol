// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "../Diamond.sol";
import {IDiamondCut, FacetCut, FacetCutAction} from "../interfaces/IDiamondCut.sol";

contract Organisation is Diamond {
    constructor(
        address _contractOwner,
        FacetCut[] memory _diamondCutFacet,
        address _init,
        bytes memory _initCalldata
    ) Diamond(_contractOwner, _diamondCutFacet, _init, _initCalldata) {}
}
