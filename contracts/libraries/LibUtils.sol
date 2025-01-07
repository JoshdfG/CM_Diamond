// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../interfaces/IFactory.sol";
import "../libraries/Error.sol";

library LibUtils {
    // Storage structure remains the same
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
        address DeployOrgDiamondFacet;
        address DeployFacet;
        address SetUpFacet;
    }

    bytes32 constant FACTORY_STORAGE_POSITION =
        keccak256("diamond.organisation.factory.storage");

    function factoryStorage() internal pure returns (Factory storage f) {
        bytes32 position = FACTORY_STORAGE_POSITION;
        assembly {
            f.slot := position
        }
    }

    function revoke(address[] calldata _individual) internal {
        LibUtils.Factory storage f = LibUtils.factoryStorage();
        require(
            f.validOrganisation[msg.sender] == true,
            "Unauthorized Operation"
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

    function register(Individual[] calldata _individual) internal {
        LibUtils.Factory storage f = LibUtils.factoryStorage();

        require(
            f.validOrganisation[msg.sender] == true,
            "Unauthorized Operation"
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
}
