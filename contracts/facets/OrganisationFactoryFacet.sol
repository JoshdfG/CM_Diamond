// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../organisation/Organisation.sol";
import "../organisation/facets/OrganisationFacet.sol";
import "../organisation/libraries/LibOrganisation.sol";
import "../interfaces/ICERTFACTORY.sol";
import {LibAppFactory} from "../libraries/LibAppFactory.sol";
import "../certificates/certificateFactory.sol";

contract OrganisationFactoryFacet {
    function initialize(address _certificateFactory) internal {
        LibAppFactory.Factory storage f = LibAppFactory.layoutStorage();
        require(!f.initialized, "Already initialized");
        f.Admin = msg.sender;
        f.certificateFactory = _certificateFactory;
        f.initialized = true;
    }

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
        LibAppFactory.Factory storage f = LibAppFactory.layoutStorage();

        f.organisationAdmin = msg.sender;

        Organisation OrganisationAddress = new Organisation(
            _organisation,
            _cohort,
            f.organisationAdmin,
            _adminName,
            _uri
        );

        initialize(f.certificateFactory);

        f.Organisations.push(address(OrganisationAddress));

        f.validOrganisation[address(OrganisationAddress)] = true;

        // f.certificateFactory = address(new certificateFactory());

        (
            address AttendanceAddr,
            address CertificateAddr,
            address mentorsSpokAddr
        ) = ICERTFACTORY(f.certificateFactory).completePackage(
                _organisation,
                _cohort,
                _uri,
                address(OrganisationAddress)
            );

        OrganisationAddress.initializeContracts(
            address(AttendanceAddr),
            address(mentorsSpokAddr),
            address(CertificateAddr)
        );

        uint orgLength = f.memberOrganisations[msg.sender].length;

        f.studentOrganisationIndex[msg.sender][
            address(OrganisationAddress)
        ] = orgLength;

        f.memberOrganisations[msg.sender].push(address(OrganisationAddress));

        Nft = address(AttendanceAddr);
        certificate = address(CertificateAddr);
        mentorsSpok = address(mentorsSpokAddr);
        organisation = address(OrganisationAddress);
    }

    function register(individual[] calldata _individual) public {
        LibAppFactory.Factory storage f = LibAppFactory.layoutStorage();
        require(
            f.validOrganisation[msg.sender] == true,
            "unauthorized Operation"
        );
        uint individualLength = _individual.length;
        for (uint i; i < individualLength; i++) {
            address uniqueStudentAddr = _individual[i]._address;
            uint orgLength = f.memberOrganisations[uniqueStudentAddr].length;
            f.studentOrganisationIndex[uniqueStudentAddr][
                msg.sender
            ] = orgLength;
            f.memberOrganisations[uniqueStudentAddr].push(msg.sender);
            if (f.uniqueStudent[uniqueStudentAddr] == false) {
                f.totalUsers++;
                f.uniqueStudent[uniqueStudentAddr] = true;
            }
        }
    }

    function revoke(address[] calldata _individual) public {
        LibAppFactory.Factory storage f = LibAppFactory.layoutStorage();

        require(
            f.validOrganisation[msg.sender] == true,
            "unauthorized Operation"
        );
        uint individualLength = _individual.length;
        for (uint i; i < individualLength; i++) {
            address uniqueIndividual = _individual[i];
            uint organisationIndex = f.studentOrganisationIndex[
                uniqueIndividual
            ][msg.sender];
            uint orgLength = f.memberOrganisations[uniqueIndividual].length;

            f.memberOrganisations[uniqueIndividual][organisationIndex] = f
                .memberOrganisations[uniqueIndividual][orgLength - 1];
            f.memberOrganisations[uniqueIndividual].pop();
        }
    }

    function getOrganizations() public view returns (address[] memory) {
        LibAppFactory.Factory storage f = LibAppFactory.layoutStorage();

        return f.Organisations;
    }

    function getUserOrganisatons(
        address _userAddress
    ) public view returns (address[] memory) {
        LibAppFactory.Factory storage f = LibAppFactory.layoutStorage();

        return (f.memberOrganisations[_userAddress]);
    }

    // function createorganisation(
    //     string memory _organisation,
    //     string memory _cohort,
    //     string memory _uri,
    //     string memory _adminName
    // )
    //     external
    //     returns (
    //         address Organisation,
    //         address Nft,
    //         address mentorsSpok,
    //         address certificate
    //     )
    // {
    //     LibAppFactory.createorganisation(
    //         _organisation,
    //         _cohort,
    //         _uri,
    //         _adminName
    //     );
    // }

    // function register(individual[] calldata _individual) public {
    //     LibAppFactory.register(_individual);
    // }

    // function revoke(address[] calldata _individual) public {
    //     LibAppFactory.revoke(_individual);
    // }

    // function getOrganizations() public view returns (address[] memory) {
    //     LibAppFactory.Factory storage f = LibAppFactory.layoutStorage();

    //     return f.Organisations;
    // }

    // function getUserOrganisatons(
    //     address _userAddress
    // ) public view returns (address[] memory) {
    //     LibAppFactory.Factory storage f = LibAppFactory.layoutStorage();

    //     return (f.memberOrganisations[_userAddress]);
    // }
}
