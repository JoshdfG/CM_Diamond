// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../interfaces/IFactory.sol";
import "../interfaces/INFT.sol";
import "../interfaces/ICERTFACTORY.sol";
import "../organisation/Organisation.sol";
import "../organisation/facets/OrganisationFacet.sol";
import "../organisation/libraries/LibOrganisation.sol";
import "../../lib/openzeppelin-contracts.git/contracts/utils/Counters.sol";

library LibAppFactory {
    // using Counters for Counters.Counter;

    // struct Storage {
    //     address issueingInstitution;
    //     bool initialized;
    //     Counters.Counter _tokenIdCounter;
    // }

    struct Factory {
        address Admin;
        address organisationAdmin;
        address certificateFactory;
        bool initialized;
        address[] Organisations;
        mapping(address => bool) validOrganisation;
        mapping(address => mapping(address => uint)) studentOrganisationIndex;
        mapping(address => address[]) memberOrganisations;
        mapping(address => bool) uniqueStudent;
        uint totalUsers;
        address cert_Admin;
    }

    // struct SchoolNft {
    //     // school nfts
    //     string name;
    //     string symbol;
    //     address admin;
    //     uint256 totalTokenId;
    //     mapping(bytes => string) daysIdToUri;
    //     mapping(bytes => uint256) daysIdToTokenId;
    // }
    // event Initialized(string name, string symbol, address admin);

    bytes32 constant FACTORY_STORAGE_POSITION =
        keccak256("diamond.standard.factory.storage");

    function layoutStorage() internal pure returns (Factory storage f) {
        bytes32 position = FACTORY_STORAGE_POSITION;
        assembly {
            f.slot := position
        }
    }

    // // Initializer function
    // function initialize(address _certificateFactory) internal {
    //     Factory storage f = layoutStorage();

    //     require(!f.initialized, "Already initialized");
    //     f.Admin = msg.sender;
    //     f.certificateFactory = _certificateFactory;
    //     f.initialized = true;
    // }

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
    //     Factory storage f = layoutStorage();
    //     f.organisationAdmin = msg.sender;
    //     Organisation OrganisationAddress = new Organisation(
    //         _organisation,
    //         _cohort,
    //         f.organisationAdmin,
    //         _adminName,
    //         _uri
    //     );

    //     LibAppFactory.initialize(f.certificateFactory);

    //     f.Organisations.push(address(OrganisationAddress));
    //     f.validOrganisation[address(OrganisationAddress)] = true;
    //     (
    //         address CertificateAddr,
    //         address AttendanceAddr,
    //         address mentorsSpokAddr
    //     ) = ICERTFACTORY(f.certificateFactory).completePackage(
    //             _organisation,
    //             _cohort,
    //             _uri,
    //             address(OrganisationAddress)
    //         );

    //     OrganisationAddress.initializeContracts(
    //         address(AttendanceAddr),
    //         address(mentorsSpokAddr),
    //         address(CertificateAddr)
    //     );
    //     uint orgLength = f.memberOrganisations[msg.sender].length;
    //     f.studentOrganisationIndex[msg.sender][
    //         address(OrganisationAddress)
    //     ] = orgLength;
    //     f.memberOrganisations[msg.sender].push(address(OrganisationAddress));

    //     Nft = address(AttendanceAddr);
    //     certificate = address(CertificateAddr);
    //     mentorsSpok = address(mentorsSpokAddr);
    //     organisation = address(OrganisationAddress);
    // }

    // function register(individual[] calldata _individual) public {
    //     Factory storage f = layoutStorage();

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

    // function revoke(address[] calldata _individual) public {
    //     Factory storage f = layoutStorage();

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
}
