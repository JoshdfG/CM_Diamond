// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {OrganisationFacet} from "../organisation/facets/OrganisationFacet.sol";
import "../facets/DiamondCutFacet.sol";
import "../facets/DiamondLoupeFacet.sol";
import "../upgradeInitializers/DiamondInit.sol";
import "../facets/OwnershipFacet.sol";
import "../organisation/Organisation.sol";
import {OrganisationSelectorsLibrary} from "../libraries/OrganisationSelectionLibrary.sol";
import "../libraries/LibUtils.sol";
import "../interfaces/ISetUpFacet.sol";

contract DeployOrgDiamondFacet {
    function deployOrgDiamond() external returns (address) {
        (
            DiamondInit diamondInit,
            DiamondCutFacet diamondCutFacet,
            DiamondLoupeFacet diamondLoupeFacet,
            OwnershipFacet ownershipFacet,
            OrganisationFacet organisationFacet
        ) = OrganisationSelectorsLibrary.setupFacets();

        FacetCut[] memory cut = new FacetCut[](4);

        bytes4[] memory diamondCutSelectors = new bytes4[](1);
        diamondCutSelectors[0] = IDiamondCut.diamondCut.selector;

        cut[0] = FacetCut({
            facetAddress: address(diamondCutFacet),
            action: FacetCutAction.Add,
            functionSelectors: diamondCutSelectors
        });
        cut[1] = FacetCut({
            facetAddress: address(diamondLoupeFacet),
            action: FacetCutAction.Add,
            functionSelectors: OrganisationSelectorsLibrary.getLoupeSelectors()
        });
        cut[2] = FacetCut({
            facetAddress: address(ownershipFacet),
            action: FacetCutAction.Add,
            functionSelectors: OrganisationSelectorsLibrary
                .getOwnershipSelectors()
        });
        cut[3] = FacetCut({
            facetAddress: address(organisationFacet),
            action: FacetCutAction.Add,
            functionSelectors: OrganisationSelectorsLibrary
                .getOrganisationSelectors()
        });
        Organisation organization = new Organisation(
            msg.sender,
            cut,
            address(diamondInit),
            abi.encode(DiamondInit.init.selector)
        );
        return address(organization);
    }
    // bytes4[] memory loupeSelectors = OrganisationSelectorsLibrary
    //     .getLoupeSelectors();
    // bytes4[] memory ownershipSelectors = OrganisationSelectorsLibrary
    //     .getOwnershipSelectors();
    // bytes4[] memory organisationSelectors = OrganisationSelectorsLibrary
    //     .getOrganisationSelectors();
}
