// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "./Diamond.sol";

contract Organisation is Diamond {
    constructor(
        address _contractOwner,
        address _diamondCutFacet
    ) Diamond(_contractOwner, _diamondCutFacet) {}
}
