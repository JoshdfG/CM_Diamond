// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/ILibDeployFacet.sol";
import "../interfaces/IFactory.sol";
import "./DeployFacet.sol";
import "../libraries/LibUtils.sol";

contract OrganisationFactoryFacet {
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
        // // Address of the facet containing the logic
        // address diamond = address(this);
        // // Encode function call with parameters
        // bytes memory data = abi.encodeWithSelector(
        //     DeployFacet.createorganisation.selector,
        //     _organisation,
        //     _cohort,
        //     _uri,
        //     _adminName
        // );
        // // Perform delegatecall
        // (bool success, bytes memory returnData) = diamond.delegatecall(data);
        // Check for successful execution
        // require(
        //     success,
        //     "delegatecall to DeployFacet.createorganisation failed"
        // );
        // LibUtils.Factory storage f = LibUtils.factoryStorage();
        // ILibDeployFacet libDeployFacet = ILibDeployFacet(f.DeployFacet);
        // libDeployFacet.deployOrgDiamond();
        // Decode the returned data
        // (organisation, Nft, mentorsSpok, certificate) = abi.decode(
        //     returnData,
        //     (address, address, address, address)
        // );
    }

    function getOrganizations() public view returns (address[] memory) {
        LibUtils.Factory storage f = LibUtils.factoryStorage();

        return f.Organisations;
    }

    function getUserOrganisatons(
        address _userAddress
    ) public view returns (address[] memory) {
        LibUtils.Factory storage f = LibUtils.factoryStorage();

        return (f.memberOrganisations[_userAddress]);
    }

    function revoke(address[] calldata _individual) external {
        LibUtils.revoke(_individual);
    }

    function register(Individual[] calldata _individual) external {
        LibUtils.register(_individual);
    }
}
