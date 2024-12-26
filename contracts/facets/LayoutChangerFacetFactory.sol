// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "./LayoutChangerFacet.sol";
// import {LibAppStorage} from "../libraries/LibAppStorage.sol";

// contract LayoutChangerFacetFactory {
//     LibAppStorage.Factory f;

//     function createLayoutChangerFacet()
//         public
//         returns (address layoutChangerFacet)
//     {
//         LayoutChangerFacet layoutChanger = new LayoutChangerFacet();
//         f.Organisations.push(address(layoutChanger));
//         f.validOrganisation[address(layoutChanger)] = true;
//         f.memberOrganisations[msg.sender].push(address(layoutChanger));

//         layoutChangerFacet = address(layoutChanger);
//     }

//     function getOrganizations() public view returns (address[] memory) {
//         return f.Organisations;
//     }

//     function getUserOrganisatons(
//         address _userAddress
//     ) public view returns (address[] memory) {
//         return (f.memberOrganisations[_userAddress]);
//     }
// }
