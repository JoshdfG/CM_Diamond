// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibOrgFactory} from "../libraries/LibOrgFactory.sol";
import "../interfaces/ICERTFACTORY.sol";
import "../libraries/LibUtils.sol";
import {OrganisationFacet} from "../organisation/facets/OrganisationFacet.sol";

library LibDeploy {
    // function initializeOrganisation(
    //     address organisation,
    //     string memory _organisation,
    //     string memory _cohort,
    //     string memory _uri,
    //     string memory _adminName
    // ) internal returns (address Nft, address mentorsSpok, address certificate) {
    //     LibUtils.Factory storage f = LibUtils.factoryStorage();
    //     (
    //         address AttendanceAddr,
    //         address CertificateAddr,
    //         address mentorsSpokAddr
    //     ) = ICERTFACTORY(f.certificateFactory).completePackage(
    //             _organisation,
    //             _cohort,
    //             _uri,
    //             organisation
    //         );
    //     OrganisationFacet(organisation).initializeContracts(
    //         AttendanceAddr,
    //         mentorsSpokAddr,
    //         CertificateAddr
    //     );
    //     uint orgLength = f.memberOrganisations[msg.sender].length;
    //     f.studentOrganisationIndex[msg.sender][organisation] = orgLength;
    //     f.memberOrganisations[msg.sender].push(organisation);
    //     Nft = AttendanceAddr;
    //     certificate = CertificateAddr;
    //     mentorsSpok = mentorsSpokAddr;
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
}
