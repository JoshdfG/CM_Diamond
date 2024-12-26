// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SchoolCertificate.sol";
import "./SchoolsNFT.sol";
import "../libraries/LibCertificateFactory.sol";

contract certificateFactory {
    using LibCertificateFactory for LibCertificateFactory.Storage;

    event ContractDeployed(
        address indexed contractAddress,
        string contractType
    );

    function setAdmin(address _admin) external {
        LibCertificateFactory.setAdmin(_admin);
    }

    function createCertificateNft(
        string memory Name,
        string memory Symbol,
        address institution
    ) public returns (address) {
        Certificate newCertificate = new Certificate(Name, Symbol, institution);
        emit ContractDeployed(address(newCertificate), "Certificate");
        return address(newCertificate);
    }

    function createAttendanceNft(
        string memory Name,
        string memory Symbol,
        string memory Uri,
        address _Admin
    ) public returns (address) {
        SchoolsNFT newSchoolsNFT = new SchoolsNFT(Name, Symbol, Uri, _Admin);
        emit ContractDeployed(address(newSchoolsNFT), "SchoolsNFT");
        return address(newSchoolsNFT);
    }

    function createMentorsSpok(
        string memory Name,
        string memory Symbol,
        address institution
    ) public returns (address) {
        Certificate newCertificate = new Certificate(Name, Symbol, institution);
        emit ContractDeployed(address(newCertificate), "MentorsSpok");
        return address(newCertificate);
    }

    function completePackage(
        string memory Name,
        string memory Symbol,
        string memory Uri,
        address _Admin
    )
        external
        returns (
            address newCertificateAdd,
            address newSchoolsNFT,
            address newMentorsSpok
        )
    {
        newCertificateAdd = createCertificateNft(Name, Symbol, _Admin);
        newSchoolsNFT = createAttendanceNft(Name, Symbol, Uri, _Admin);
        newMentorsSpok = createMentorsSpok(Name, Symbol, _Admin);
    }
}
