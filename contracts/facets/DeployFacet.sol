// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibOrgFactory} from "../libraries/LibOrgFactory.sol";
import "../interfaces/ICERTFACTORY.sol";
import "../interfaces/IDeployOrgDiamondFacet.sol";
import "../libraries/LibUtils.sol";
import {OrganisationFacet} from "../organisation/facets/OrganisationFacet.sol";
import "../../contracts/facets/DeployOrgDiamondFacet.sol";

// import "../facets/DiamondCutFacet.sol";
// import "../facets/DiamondLoupeFacet.sol";
// import "../upgradeInitializers/DiamondInit.sol";
// import "../facets/OwnershipFacet.sol";
// import "../organisation/Organisation.sol";

contract DeployFacet {
    // function createorganisation(
    //     string memory _organisation,
    //     string memory _cohort,
    //     string memory _uri,
    //     string memory _adminName
    // )
    //     external
    //     returns (
    //         address organisation,
    //         address Nft,
    //         address mentorsSpok,
    //         address certificate
    //     )
    // {
    //     LibUtils.Factory storage f = LibUtils.factoryStorage();
    //     f.organisationAdmin = msg.sender;

    //     address organisationAddress = LibOrgFactory.deployOrgDiamond();
    //     LibOrgFactory.initialize(f.certificateFactory);

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
    //         AttendanceAddr,
    //         mentorsSpokAddr,
    //         CertificateAddr
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

    function createorganisation(
        string memory _organisation,
        string memory _cohort,
        string memory _uri,
        string memory _adminName
    )
        external
        returns (
            address organisation,
            address Nft,
            address mentorsSpok,
            address certificate
        )
    {
        LibUtils.Factory storage f = LibUtils.factoryStorage();

        f.organisationAdmin = msg.sender;

        // Use delegatecall to call deployOrgDiamond in DeployOrgDiamondFacet
        address organisationAddress;
        // bytes memory data = abi.encodeWithSelector(
        //     DeployOrgDiamondFacet.deployOrgDiamond.selector
        // );

        // (bool success, bytes memory result) = address(this).delegatecall(data);
        // require(success, "Delegatecall to deployOrgDiamond failed");
        IDeployOrgDiamondFacet(f.DeployOrgDiamondFacet).deployOrgDiamond();

        LibOrgFactory.initialize(f.certificateFactory);

        f.Organisations.push(address(organisationAddress));

        f.validOrganisation[address(organisationAddress)] = true;

        (
            address AttendanceAddr,
            address CertificateAddr,
            address mentorsSpokAddr
        ) = ICERTFACTORY(f.certificateFactory).completePackage(
                _organisation,
                _cohort,
                _uri,
                address(organisationAddress)
            );

        OrganisationFacet(organisationAddress).initializeContracts(
            address(AttendanceAddr),
            address(mentorsSpokAddr),
            address(CertificateAddr)
        );

        uint orgLength = f.memberOrganisations[msg.sender].length;

        f.studentOrganisationIndex[msg.sender][
            address(organisationAddress)
        ] = orgLength;

        f.memberOrganisations[msg.sender].push(address(organisationAddress));

        Nft = address(AttendanceAddr);
        certificate = address(CertificateAddr);
        mentorsSpok = address(mentorsSpokAddr);
        organisation = address(organisationAddress);
    }
}
