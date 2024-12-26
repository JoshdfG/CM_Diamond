// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../interfaces/INFT.sol";
import "../../interfaces/IFactory.sol";
import "../../libraries/Events.sol";
import {LibOrganisation} from "../libraries/LibOrganisation.sol";
import {IOrganisation} from "../interfaces/IOrganisation.sol";
import "../../libraries/Error.sol";

contract OrganisationFacet {
    function deploy(
        string calldata _organization,
        string calldata _cohort,
        address _moderator,
        string calldata _adminName,
        string calldata _uri
    ) external {
        LibOrganisation.deploy(
            _organization,
            _cohort,
            _moderator,
            _adminName,
            _uri
        );
    }

    function initializeContracts(
        address _NftContract,
        address _certificateContract,
        address _spokContract
    ) external {
        LibOrganisation.initializeContracts(
            _NftContract,
            _certificateContract,
            _spokContract
        );
    }

    function requestNameCorrection() external {
        LibOrganisation.requestNameCorrection();
    }

    function editStudentName(Individual[] calldata _studentList) external {
        LibOrganisation.editStudentName(_studentList);
    }

    function editMentorsName(Individual[] calldata _mentorsList) external {
        LibOrganisation.editMentorsName(_mentorsList);
    }

    function createAttendance(
        bytes calldata _lectureId,
        string calldata _uri,
        string calldata _topic
    ) external {
        LibOrganisation.createAttendance(_lectureId, _uri, _topic);
    }

    // @dev: Function to mint spok
    function mintMentorsSpok(string memory Uri) external {
        LibOrganisation.mintMentorsSpok(Uri);
    }

    function editTopic(
        bytes memory _lectureId,
        string calldata _topic
    ) external {
        LibOrganisation.editTopic(_lectureId, _topic);
    }

    function signAttendance(bytes memory _lectureId) external {
        LibOrganisation.signAttendance(_lectureId);
    }

    function mentorHandover(address newMentor) external {
        LibOrganisation.mentorHandover(newMentor);
    }

    function openAttendance(bytes calldata _lectureId) external {
        LibOrganisation.openAttendance(_lectureId);
    }

    function closeAttendance(bytes calldata _lectureId) external {
        LibOrganisation.closeAttendance(_lectureId);
    }

    function recordResults(
        uint256 testId,
        string calldata _resultCid
    ) external {
        LibOrganisation.recordResults(testId, _resultCid);
    }

    function getResultCid() external view returns (string[] memory) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.resultCid;
    }

    function evictStudents(address[] calldata studentsToRevoke) external {
        LibOrganisation.evictStudents(studentsToRevoke);
    }

    function removeMentor(address[] calldata rouge_mentors) external {
        LibOrganisation.removeMentor(rouge_mentors);
    }

    function getNameArray(
        address[] calldata _students
    ) external view returns (string[] memory) {
        return LibOrganisation.getNameArray(_students);
    }

    function mintCertificate(string memory Uri) external {
        LibOrganisation.mintCertificate(Uri);
    }

    //VIEW FUNCTION
    function listStudents() external view returns (address[] memory) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.students;
    }

    function verifyStudent(address _student) external view returns (bool) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.isStudent[_student];
    }

    function getStudentName(
        address _student
    ) external view returns (string memory name) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        if (org.isStudent[_student] == false) revert Error.not_valid_student();
        return org.studentsData[_student]._name;
    }

    function getStudentAttendanceRatio(
        address _student
    ) external view returns (uint attendace, uint TotalClasses) {
        (attendace, TotalClasses) = LibOrganisation.getStudentAttendanceRatio(_student);
    }

    function getStudentsPresent(
        bytes memory _lectureId
    ) external view returns (uint) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.lectureInstance[_lectureId].studentsPresent;
    }

    function listClassesAttended(
        address _student
    ) external view returns (bytes[] memory) {
        return LibOrganisation.listClassesAttended(_student);
    }

    function getLectureIds() external view returns (bytes[] memory) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.LectureIdCollection;
    }

    function getLectureData(
        bytes calldata _lectureId
    ) external view returns (LibOrganisation.lectureData memory) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        if (org.lectureIdUsed[_lectureId] == false)
            revert Error.not_valid_lecture_id();
        return org.lectureInstance[_lectureId];
    }

    function listMentors() external view returns (address[] memory) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.mentors;
    }

    function verifyMentor(address _mentor) external view returns (bool) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.isStaff[_mentor];
    }

    function getMentorsName(
        address _Mentor
    ) external view returns (string memory name) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        if (org.isStaff[_Mentor] == false) revert Error.not_valid_Moderator();
        return org.mentorsData[_Mentor]._name;
    }

    function getClassesTaugth(
        address _Mentor
    ) external view returns (bytes[] memory) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        if (org.isStaff[_Mentor] == false) revert Error.not_valid_Moderator();
        return org.moderatorsTopic[_Mentor];
    }

    function getMentorOnDuty() external view returns (address) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.mentorOnDuty;
    }

    function getModerator() external view returns (address) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.moderator;
    }

    function getOrganizationName() external view returns (string memory) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.organization;
    }

    function getCohortName() external view returns (string memory) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.cohort;
    }

    function getOrganisationImageUri() external view returns (string memory) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.organisationImageUri;
    }

    function toggleOrganizationStatus() external {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        org.isOngoing = !org.isOngoing;
    }

    function getOrganizationStatus() external view returns (bool) {
        LibOrganisation.Organisation storage org = LibOrganisation.orgStorage();

        return org.isOngoing;
    }
}
