// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/ICERTFACTORY.sol";
import "../organisation/Organisation.sol";
import "../organisation/facets/OrganisationFacet.sol";
import "../libraries/LibUtils.sol";
import "../facets/DiamondCutFacet.sol";
import "../facets/DiamondLoupeFacet.sol";
import "../upgradeInitializers/DiamondInit.sol";
import "../facets/OwnershipFacet.sol";

library LibOrgFactory {
    function initialize(address _certificateFactory) internal {
        LibUtils.Factory storage f = LibUtils.factoryStorage();
        require(!f.initialized, "Already initialized");
        f.Admin = msg.sender;
        f.certificateFactory = _certificateFactory;
        f.initialized = true;
    }

    function getOrganisationSelectors()
        internal
        pure
        returns (bytes4[] memory)
    {
        string[40] memory signatures = [
            "deploy()",
            "initializeContracts()",
            "registerStudents()",
            "registerStaffs()",
            "TransferOwnership()",
            "requestNameCorrection()",
            "editStudentName()",
            "editMentorsName()",
            "createAttendance()",
            "openAttendance()",
            "closeAttendance()",
            "signAttendance()",
            "mintMentorsSpok()",
            "editTopic()",
            "mentorHandover()",
            "recordResults()",
            "getResultCid()",
            "evictStudents()",
            "removeMentor()",
            "getNameArray()",
            "mintCertificate()",
            "listStudents()",
            "verifyStudent()",
            "getStudentName()",
            "getStudentAttendanceRatio()",
            "getStudentsPresent()",
            "listClassesAttended()",
            "getLectureIds()",
            "getLectureData()",
            "listMentors()",
            "verifyMentor()",
            "getMentorsName()",
            "getClassesTaugth()",
            "getMentorOnDuty()",
            "getModerator()",
            "getOrganizationName()",
            "getCohortName()",
            "getOrganisationImageUri()",
            "toggleOrganizationStatus()",
            "getOrganizationStatus()"
        ];

        bytes4[] memory selectors = new bytes4[](signatures.length);
        for (uint256 i = 0; i < signatures.length; i++) {
            selectors[i] = bytes4(keccak256(bytes(signatures[i])));
        }
        return selectors;
    }

    function getLoupeSelectors() internal pure returns (bytes4[] memory) {
        string[5] memory signatures = [
            "facets()",
            "facetFunctionSelectors()",
            "facetAddresses()",
            "facetAddress()",
            "supportsInterface()"
        ];

        bytes4[] memory selectors = new bytes4[](signatures.length);
        for (uint256 i = 0; i < signatures.length; i++) {
            selectors[i] = bytes4(keccak256(bytes(signatures[i])));
        }
        return selectors;
    }

    function deployOrgDiamond() internal returns (address) {
        // Create facets
        (
            DiamondInit diamondinit,
            DiamondCutFacet diamondcutfacet,
            DiamondLoupeFacet diamondloupefacet,
            OwnershipFacet ownershipfacet,
            OrganisationFacet organisationfacet
        ) = setupFacets();

        // Initialize cut array
        FacetCut[] memory cut;
        // = new FacetCut[](4)
        // Get selectors
        bytes4[] memory diamondCutSelectors;
        // = new bytes4[](1)
        diamondCutSelectors[0] = IDiamondCut.diamondCut.selector;

        bytes4[] memory loupeSelectors = getLoupeSelectors();
        // loupeSelectors[0] = IDiamondLoupe.facets.selector;
        // loupeSelectors[1] = IDiamondLoupe.facetFunctionSelectors.selector;
        // loupeSelectors[2] = IDiamondLoupe.facetAddresses.selector;
        // loupeSelectors[3] = IDiamondLoupe.facetAddress.selector;
        // loupeSelectors[4] = IERC165.supportsInterface.selector;

        bytes4[] memory ownershipSelectors;
        // = new bytes4[](2)
        ownershipSelectors[0] = IERC173.transferOwnership.selector;
        ownershipSelectors[1] = IERC173.owner.selector;

        // Get organization selectors
        bytes4[] memory organisationSelectors = getOrganisationSelectors();

        // Set up cuts
        cut[0] = FacetCut({
            facetAddress: address(diamondcutfacet),
            action: FacetCutAction.Add,
            functionSelectors: diamondCutSelectors
        });

        cut[1] = FacetCut({
            facetAddress: address(diamondloupefacet),
            action: FacetCutAction.Add,
            functionSelectors: loupeSelectors
        });

        cut[2] = FacetCut({
            facetAddress: address(ownershipfacet),
            action: FacetCutAction.Add,
            functionSelectors: ownershipSelectors
        });

        cut[3] = FacetCut({
            facetAddress: address(organisationfacet),
            action: FacetCutAction.Add,
            functionSelectors: organisationSelectors
        });

        // Deploy organization
        return
            address(
                new Organisation(
                    msg.sender,
                    cut,
                    address(diamondinit),
                    abi.encode(DiamondInit.init.selector)
                )
            );
    }

    function setupFacets()
        internal
        returns (
            DiamondInit diamondinit,
            DiamondCutFacet diamondcutfacet,
            DiamondLoupeFacet diamondloupefacet,
            OwnershipFacet ownershipfacet,
            OrganisationFacet organisationfacet
        )
    {
        diamondinit = new DiamondInit();
        diamondcutfacet = new DiamondCutFacet();
        diamondloupefacet = new DiamondLoupeFacet();
        ownershipfacet = new OwnershipFacet();
        organisationfacet = new OrganisationFacet();
    }

    // function createorganisation(
    //     string memory _organisation,
    //     string memory _cohort,
    //     string memory _uri,
    //     string memory _adminName
    // )
    //     internal
    //     returns (
    //         address organisation,
    //         address Nft,
    //         address mentorsSpok,
    //         address certificate
    //     )
    // {
    //     LibOrgFactory.Factory storage f = LibOrgFactory.factoryStorage();

    //     f.organisationAdmin = msg.sender;

    //     address organisationAddress = deployOrgDiamond();

    //     initialize(f.certificateFactory);

    //     f.Organisations.push(address(organisationAddress));

    //     f.validOrganisation[address(organisationAddress)] = true;

    //     (
    //         address AttendanceAddr,
    //         address CertificateAddr,
    //         address mentorsSpokAddr
    //     ) = ICERTFACTORY(f.certificateFactory).completePackage(
    //             _organisation,
    //             _cohort,
    //             _uri,
    //             address(organisationAddress)
    //         );

    //     OrganisationFacet(organisationAddress).initializeContracts(
    //         address(AttendanceAddr),
    //         address(mentorsSpokAddr),
    //         address(CertificateAddr)
    //     );

    //     uint orgLength = f.memberOrganisations[msg.sender].length;

    //     f.studentOrganisationIndex[msg.sender][
    //         address(organisationAddress)
    //     ] = orgLength;

    //     f.memberOrganisations[msg.sender].push(address(organisationAddress));

    //     Nft = address(AttendanceAddr);
    //     certificate = address(CertificateAddr);
    //     mentorsSpok = address(mentorsSpokAddr);
    //     organisation = address(organisationAddress);
    // }

    // function deployOrgDiamond() internal returns (address) {
    //     DiamondInit diamondInit = new DiamondInit();
    //     DiamondCutFacet diamondCutFacet = new DiamondCutFacet();
    //     DiamondLoupeFacet diamondLoupeFacet = new DiamondLoupeFacet();
    //     OwnershipFacet ownershipFacet = new OwnershipFacet();
    //     OrganisationFacet organisationFacet = new OrganisationFacet();

    //     FacetCut[] memory cut = new FacetCut[](4);

    //     bytes4[] memory diamondCutSelectors = new bytes4[](1);
    //     diamondCutSelectors[0] = IDiamondCut.diamondCut.selector;

    //     bytes4[] memory loupeSelectors = new bytes4[](5);
    //     loupeSelectors[0] = IDiamondLoupe.facets.selector;
    //     loupeSelectors[1] = IDiamondLoupe.facetFunctionSelectors.selector;
    //     loupeSelectors[2] = IDiamondLoupe.facetAddresses.selector;
    //     loupeSelectors[3] = IDiamondLoupe.facetAddress.selector;
    //     loupeSelectors[4] = IERC165.supportsInterface.selector;

    //     bytes4[] memory ownershipSelectors = new bytes4[](2);
    //     ownershipSelectors[0] = IERC173.transferOwnership.selector;
    //     ownershipSelectors[1] = IERC173.owner.selector;

    //     bytes4[] memory organisationSelectors = new bytes4[](36);
    //     organisationSelectors[0] = OrganisationFacet.deploy.selector;
    //     organisationSelectors[1] = OrganisationFacet
    //         .initializeContracts
    //         .selector;
    //     organisationSelectors[2] = OrganisationFacet
    //         .requestNameCorrection
    //         .selector;
    //     organisationSelectors[3] = OrganisationFacet.editStudentName.selector;
    //     organisationSelectors[4] = OrganisationFacet.editMentorsName.selector;
    //     organisationSelectors[5] = OrganisationFacet.createAttendance.selector;
    //     organisationSelectors[6] = OrganisationFacet.mintMentorsSpok.selector;
    //     organisationSelectors[7] = OrganisationFacet.editTopic.selector;
    //     organisationSelectors[8] = OrganisationFacet.signAttendance.selector;
    //     organisationSelectors[9] = OrganisationFacet.mentorHandover.selector;
    //     organisationSelectors[10] = OrganisationFacet.openAttendance.selector;
    //     organisationSelectors[11] = OrganisationFacet.closeAttendance.selector;
    //     organisationSelectors[12] = OrganisationFacet.recordResults.selector;
    //     organisationSelectors[13] = OrganisationFacet.getResultCid.selector;
    //     organisationSelectors[14] = OrganisationFacet.evictStudents.selector;
    //     organisationSelectors[15] = OrganisationFacet.removeMentor.selector;
    //     organisationSelectors[16] = OrganisationFacet.getNameArray.selector;
    //     organisationSelectors[17] = OrganisationFacet.mintCertificate.selector;
    //     organisationSelectors[18] = OrganisationFacet.listStudents.selector;
    //     organisationSelectors[19] = OrganisationFacet.verifyStudent.selector;
    //     organisationSelectors[20] = OrganisationFacet.getStudentName.selector;
    //     organisationSelectors[21] = OrganisationFacet
    //         .getStudentAttendanceRatio
    //         .selector;
    //     organisationSelectors[22] = OrganisationFacet
    //         .getStudentsPresent
    //         .selector;
    //     organisationSelectors[23] = OrganisationFacet
    //         .listClassesAttended
    //         .selector;
    //     organisationSelectors[24] = OrganisationFacet.getLectureData.selector;
    //     organisationSelectors[25] = OrganisationFacet.listMentors.selector;
    //     organisationSelectors[26] = OrganisationFacet.verifyMentor.selector;
    //     organisationSelectors[27] = OrganisationFacet.getMentorsName.selector;
    //     organisationSelectors[28] = OrganisationFacet.getClassesTaugth.selector;
    //     organisationSelectors[29] = OrganisationFacet.getMentorOnDuty.selector;
    //     organisationSelectors[30] = OrganisationFacet.getModerator.selector;
    //     organisationSelectors[31] = OrganisationFacet
    //         .getOrganizationName
    //         .selector;
    //     organisationSelectors[32] = OrganisationFacet.getCohortName.selector;
    //     organisationSelectors[33] = OrganisationFacet
    //         .getOrganisationImageUri
    //         .selector;
    //     organisationSelectors[34] = OrganisationFacet
    //         .toggleOrganizationStatus
    //         .selector;
    //     organisationSelectors[35] = OrganisationFacet
    //         .getOrganizationStatus
    //         .selector;

    //     cut[0] = FacetCut({
    //         facetAddress: address(diamondCutFacet),
    //         action: FacetCutAction.Add,
    //         functionSelectors: diamondCutSelectors
    //     });

    //     cut[1] = FacetCut({
    //         facetAddress: address(diamondLoupeFacet),
    //         action: FacetCutAction.Add,
    //         functionSelectors: loupeSelectors
    //     });

    //     cut[2] = FacetCut({
    //         facetAddress: address(ownershipFacet),
    //         action: FacetCutAction.Add,
    //         functionSelectors: ownershipSelectors
    //     });

    //     cut[3] = FacetCut({
    //         facetAddress: address(organisationFacet),
    //         action: FacetCutAction.Add,
    //         functionSelectors: organisationSelectors
    //     });

    //     Organisation organization = new Organisation(
    //         msg.sender,
    //         cut,
    //         address(diamondInit),
    //         abi.encode(DiamondInit.init.selector)
    //     );

    //     return address(organization);
    // }

    // function createorganisation(
    //     string memory _organisation,
    //     string memory _cohort,
    //     string memory _uri,
    //     string memory _adminName
    // )
    //     internal
    //     returns (
    //         address organisation,
    //         address Nft,
    //         address mentorsSpok,
    //         address certificate
    //     )
    // {
    //     LibOrgFactory.Factory storage f = LibOrgFactory.factoryStorage();

    //     f.organisationAdmin = msg.sender;

    //     address organisationAddress = deployOrgDiamond();

    //     initialize(f.certificateFactory);

    //     f.Organisations.push(address(organisationAddress));

    //     f.validOrganisation[address(organisationAddress)] = true;

    //     (
    //         address AttendanceAddr,
    //         address CertificateAddr,
    //         address mentorsSpokAddr
    //     ) = ICERTFACTORY(f.certificateFactory).completePackage(
    //             _organisation,
    //             _cohort,
    //             _uri,
    //             address(organisationAddress)
    //         );

    //     OrganisationFacet(organisationAddress).initializeContracts(
    //         address(AttendanceAddr),
    //         address(mentorsSpokAddr),
    //         address(CertificateAddr)
    //     );

    //     uint orgLength = f.memberOrganisations[msg.sender].length;

    //     f.studentOrganisationIndex[msg.sender][
    //         address(organisationAddress)
    //     ] = orgLength;

    //     f.memberOrganisations[msg.sender].push(address(organisationAddress));

    //     Nft = address(AttendanceAddr);
    //     certificate = address(CertificateAddr);
    //     mentorsSpok = address(mentorsSpokAddr);
    //     organisation = address(organisationAddress);
    // }

    // function revoke(address[] calldata _individual) internal {
    //     LibOrgFactory.Factory storage f = LibOrgFactory.factoryStorage();
    //     require(
    //         f.validOrganisation[msg.sender] == true,
    //         "unauthorized Operation"
    //     );
    //     uint individualLength = _individual.length;
    //     for (uint i; i < individualLength; i++) {
    //         address uniqueIndividual = _individual[i];
    //         uint organisationIndex = f.studentOrganisationIndex[
    //             uniqueIndividual
    //         ][msg.sender];
    //         uint orgLength = f.memberOrganisations[uniqueIndividual].length;

    //         f.memberOrganisations[uniqueIndividual][organisationIndex] = f
    //             .memberOrganisations[uniqueIndividual][orgLength - 1];
    //         f.memberOrganisations[uniqueIndividual].pop();
    //     }
    // }

    // function register(Individual[] calldata _individual) internal {
    //     LibOrgFactory.Factory storage f = LibOrgFactory.factoryStorage();

    //     require(
    //         f.validOrganisation[msg.sender] == true,
    //         "unauthorized Operation"
    //     );
    //     uint individualLength = _individual.length;
    //     for (uint i; i < individualLength; i++) {
    //         address uniqueStudentAddr = _individual[i]._address;
    //         uint orgLength = f.memberOrganisations[uniqueStudentAddr].length;
    //         f.studentOrganisationIndex[uniqueStudentAddr][
    //             msg.sender
    //         ] = orgLength;
    //         f.memberOrganisations[uniqueStudentAddr].push(msg.sender);
    //         if (f.uniqueStudent[uniqueStudentAddr] == false) {
    //             f.totalUsers++;
    //             f.uniqueStudent[uniqueStudentAddr] = true;
    //         }
    //     }
    // }
}
