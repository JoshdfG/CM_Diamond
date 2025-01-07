// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../organisation/facets/OrganisationFacet.sol";
import "../facets/DiamondLoupeFacet.sol";
import "../facets/OwnershipFacet.sol";
import {OrganisationFacet} from "../organisation/facets/OrganisationFacet.sol";
import "../facets/DiamondLoupeFacet.sol";
import "../upgradeInitializers/DiamondInit.sol";
import "../facets/OwnershipFacet.sol";
import "../facets/DiamondCutFacet.sol";

library OrganisationSelectorsLibrary {
    function getOrganisationSelectors()
        internal
        pure
        returns (bytes4[] memory)
    {
        bytes4[] memory selectors;

        selectors[0] = OrganisationFacet.deploy.selector;
        selectors[1] = OrganisationFacet.initializeContracts.selector;
        selectors[2] = OrganisationFacet.registerStudents.selector;
        selectors[3] = OrganisationFacet.registerStaffs.selector;
        selectors[4] = OrganisationFacet.TransferOwnership.selector;
        selectors[5] = OrganisationFacet.requestNameCorrection.selector;
        selectors[6] = OrganisationFacet.editStudentName.selector;
        selectors[7] = OrganisationFacet.editMentorsName.selector;
        selectors[8] = OrganisationFacet.createAttendance.selector;
        selectors[9] = OrganisationFacet.openAttendance.selector;
        selectors[10] = OrganisationFacet.closeAttendance.selector;
        selectors[11] = OrganisationFacet.signAttendance.selector;
        selectors[12] = OrganisationFacet.mintMentorsSpok.selector;
        selectors[13] = OrganisationFacet.editTopic.selector;
        selectors[14] = OrganisationFacet.mentorHandover.selector;
        selectors[15] = OrganisationFacet.recordResults.selector;
        selectors[16] = OrganisationFacet.getResultCid.selector;
        selectors[17] = OrganisationFacet.evictStudents.selector;
        selectors[18] = OrganisationFacet.removeMentor.selector;
        selectors[19] = OrganisationFacet.getNameArray.selector;
        selectors[20] = OrganisationFacet.mintCertificate.selector;
        selectors[21] = OrganisationFacet.listStudents.selector;
        selectors[22] = OrganisationFacet.verifyStudent.selector;
        selectors[23] = OrganisationFacet.getStudentName.selector;
        selectors[24] = OrganisationFacet.getStudentAttendanceRatio.selector;
        selectors[25] = OrganisationFacet.getStudentsPresent.selector;
        selectors[26] = OrganisationFacet.listClassesAttended.selector;
        selectors[27] = OrganisationFacet.getLectureIds.selector;
        selectors[28] = OrganisationFacet.getLectureData.selector;
        selectors[29] = OrganisationFacet.listMentors.selector;
        selectors[30] = OrganisationFacet.verifyMentor.selector;
        selectors[31] = OrganisationFacet.getMentorsName.selector;
        selectors[32] = OrganisationFacet.getClassesTaugth.selector;
        selectors[33] = OrganisationFacet.getMentorOnDuty.selector;
        selectors[34] = OrganisationFacet.getModerator.selector;
        selectors[35] = OrganisationFacet.getOrganizationName.selector;
        selectors[36] = OrganisationFacet.getCohortName.selector;
        selectors[37] = OrganisationFacet.getOrganisationImageUri.selector;
        selectors[38] = OrganisationFacet.toggleOrganizationStatus.selector;
        selectors[39] = OrganisationFacet.getOrganizationStatus.selector;

        return selectors;
    }

    function getLoupeSelectors() internal pure returns (bytes4[] memory) {
        bytes4[] memory loupeSelectors;
        loupeSelectors[0] = IDiamondLoupe.facets.selector;
        loupeSelectors[1] = IDiamondLoupe.facetFunctionSelectors.selector;
        loupeSelectors[2] = IDiamondLoupe.facetAddresses.selector;
        loupeSelectors[3] = IDiamondLoupe.facetAddress.selector;
        loupeSelectors[4] = IERC165.supportsInterface.selector;
        return loupeSelectors;
    }

    function getOwnershipSelectors() internal pure returns (bytes4[] memory) {
        bytes4[] memory ownershipSelectors;
        ownershipSelectors[0] = IERC173.transferOwnership.selector;
        ownershipSelectors[1] = IERC173.owner.selector;
        return ownershipSelectors;
    }

    function setupFacets()
        internal
        returns (
            DiamondInit diamondInit,
            DiamondCutFacet diamondCutFacet,
            DiamondLoupeFacet diamondLoupeFacet,
            OwnershipFacet ownershipFacet,
            OrganisationFacet organisationFacet
        )
    {
        diamondInit = new DiamondInit();
        diamondCutFacet = new DiamondCutFacet();
        diamondLoupeFacet = new DiamondLoupeFacet();
        ownershipFacet = new OwnershipFacet();
        organisationFacet = new OrganisationFacet();
    }
}
