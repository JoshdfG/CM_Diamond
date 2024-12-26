// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../interfaces/IFactory.sol";
import "../interfaces/INFT.sol";
import "../libraries/Error.sol";
import "../libraries/Events.sol";

library LibAppStorage {
    struct Layout {
        uint256 currentNo;
        string name;
    }

    // struct Factory {
    //     address[] Organisations;
    //     address OrganisationAddress;
    //     mapping(address => bool) validOrganisation;
    //     mapping(address => address[]) memberOrganisations;
    // }

    struct Organisation {
        bool isOngoing;
        /**
         * ============================================================ *
         * --------------------- ORGANIZATION RECORD------------------- *
         * ============================================================ *
         */
        string organization;
        string cohort;
        string certiificateURI;
        address organisationFactory;
        address NftContract;
        address certificateContract;
        bool certificateIssued;
        string organisationImageUri;
        address spokContract;
        string spokURI;
        bool spokMinted;
        mapping(address => bool) requestNameCorrection;
        /**
         * ============================================================ *
         * --------------------- ATTENDANCE RECORD--------------------- *
         * ============================================================ *
         */
        bytes[] LectureIdCollection;
        mapping(bytes => lectureData) lectureInstance;
        mapping(bytes => bool) lectureIdUsed;
        /**
         * ============================================================ *
         * --------------------- STUDENTS RECORD------------------- *
         * ============================================================ *
         */
        address[] students;
        mapping(address => individual) studentsData;
        mapping(address => uint) indexInStudentsArray;
        mapping(address => uint) studentsTotalAttendance;
        mapping(address => bool) isStudent;
        mapping(address => bytes[]) classesAttended;
        mapping(address => mapping(bytes => bool)) IndividualAttendanceRecord;
        string[] resultCid;
        mapping(uint256 => bool) testIdUsed;
        /**
         * ============================================================ *
         * --------------------- STAFFS RECORD------------------------- *
         * ============================================================ *
         */
        address moderator;
        address mentorOnDuty;
        address[] mentors;
        mapping(address => uint) indexInMentorsArray;
        mapping(address => bytes[]) moderatorsTopic;
        mapping(address => bool) isStaff;
        mapping(address => individual) mentorsData;
    }

    struct lectureData {
        address mentorOnDuty;
        string topic;
        string uri;
        uint attendanceStartTime;
        uint studentsPresent;
        bool status;
    }

    // MODIFIERS

    function onlyModerator() private view {
        Organisation storage org = layoutStorage();

        if (msg.sender != org.moderator) {
            revert Error.not_valid_Moderator();
        }
    }

    function onlyMentorOnDuty() private view {
        Organisation storage org = layoutStorage();

        if (msg.sender != org.mentorOnDuty) {
            revert Error.not_valid_mentor();
        }
    }

    function onlyStudents() private view {
        Organisation storage org = layoutStorage();
        if (org.isStudent[msg.sender] == false) {
            revert Error.not_valid_student();
        }
    }

    function onlyStudentOrStaff() private view {
        Organisation storage org = layoutStorage();

        if (
            !(org.isStudent[msg.sender] == true ||
                msg.sender == org.moderator ||
                org.isStaff[msg.sender] == true)
        ) {
            revert("NOT ALLOWED TO REQUEST A NAME CHANGE");
        }
    }

    function onlyStaff() private view {
        Organisation storage org = layoutStorage();

        if (!(msg.sender == org.moderator || org.isStaff[msg.sender])) {
            revert("NOT MODERATOR");
        }
    }

    // organisation logic

    function deploy(
        string memory _organization,
        string memory _cohort,
        address _moderator,
        string memory _adminName,
        string memory _uri
    ) external {
        Organisation storage org = layoutStorage();
        org.moderator = _moderator;
        org.organization = _organization;
        org.cohort = _cohort;
        org.organisationFactory = msg.sender;
        org.mentorOnDuty = _moderator;
        org.indexInMentorsArray[_moderator] = org.mentors.length;
        org.mentors.push(_moderator);
        org.isStaff[_moderator] = true;
        org.mentorsData[_moderator]._address = _moderator;
        org.mentorsData[_moderator]._name = _adminName;
        org.organisationImageUri = _uri;
        org.isOngoing = true;
    }

    function initializeContracts(
        address _NftContract,
        address _certificateContract,
        address _spokContract
    ) external {
        Organisation storage org = layoutStorage();

        if (msg.sender != org.organisationFactory)
            revert Error.not_Autorized_Caller();
        org.NftContract = _NftContract;
        org.certificateContract = _certificateContract;
        org.spokContract = _spokContract;
    }

    function registerStaffs(individual[] calldata staffList) external {
        Organisation storage org = layoutStorage();

        onlyModerator();
        uint staffLength = staffList.length;
        for (uint i; i < staffLength; i++) {
            if (
                org.isStaff[staffList[i]._address] == false &&
                org.isStudent[staffList[i]._address] == false
            ) {
                org.mentorsData[staffList[i]._address] = staffList[i];
                org.isStaff[staffList[i]._address] = true;
                org.indexInMentorsArray[staffList[i]._address] = org
                    .mentors
                    .length;
                org.mentors.push(staffList[i]._address);
            }
        }
        IFACTORY(org.organisationFactory).register(staffList);
        emit Events.staffsRegistered(staffList.length);
    }

    function TransferOwnership(address newModerator) external {
        Organisation storage org = layoutStorage();

        onlyModerator();
        assert(newModerator != address(0));
        org.moderator = newModerator;
    }

    function registerStudents(individual[] calldata _studentList) external {
        Organisation storage org = layoutStorage();

        onlyModerator();
        uint studentLength = _studentList.length;
        for (uint i; i < studentLength; i++) {
            if (
                org.isStudent[_studentList[i]._address] == false &&
                org.isStaff[_studentList[i]._address] == false
            ) {
                org.studentsData[_studentList[i]._address] = _studentList[i];
                org.indexInStudentsArray[_studentList[i]._address] = org
                    .students
                    .length;
                org.students.push(_studentList[i]._address);
                org.isStudent[_studentList[i]._address] = true;
            }
        }
        IFACTORY(org.organisationFactory).register(_studentList);
        emit Events.studentsRegistered(_studentList.length);
    }

    function RequestNameCorrection() external {
        Organisation storage org = layoutStorage();

        onlyStudentOrStaff();
        if (org.requestNameCorrection[msg.sender] == true)
            revert Error.already_requested();
        org.requestNameCorrection[msg.sender] = true;
        emit Events.nameChangeRequested(msg.sender);
    }

    function editStudentName(individual[] memory _studentList) external {
        Organisation storage org = layoutStorage();

        onlyStudentOrStaff();
        uint studentLength = _studentList.length;
        for (uint i; i < studentLength; i++) {
            if (org.requestNameCorrection[_studentList[i]._address] == true) {
                org.studentsData[_studentList[i]._address] = _studentList[i];
                org.requestNameCorrection[_studentList[i]._address] = false;
            }
        }
        emit Events.studentNamesChanged(_studentList.length);
    }

    function editMentorsName(individual[] memory _mentorsList) external {
        Organisation storage org = layoutStorage();

        onlyStudentOrStaff();
        uint MentorsLength = _mentorsList.length;
        for (uint i; i < MentorsLength; i++) {
            if (org.requestNameCorrection[_mentorsList[i]._address] == true) {
                org.mentorsData[_mentorsList[i]._address] = _mentorsList[i];
                org.requestNameCorrection[_mentorsList[i]._address] = false;
            }
        }
        emit Events.StaffNamesChanged(_mentorsList.length);
    }

    function createAttendance(
        bytes calldata _lectureId,
        string calldata _uri,
        string calldata _topic
    ) external {
        Organisation storage org = layoutStorage();

        onlyMentorOnDuty();
        if (org.lectureIdUsed[_lectureId] == true)
            revert Error.lecture_id_already_used();
        org.lectureIdUsed[_lectureId] = true;
        org.LectureIdCollection.push(_lectureId);
        org.lectureInstance[_lectureId].uri = _uri;
        org.lectureInstance[_lectureId].topic = _topic;
        org.lectureInstance[_lectureId].mentorOnDuty = msg.sender;
        org.moderatorsTopic[msg.sender].push(_lectureId);

        INFT(org.NftContract).setDayUri(_lectureId, _uri);
        emit Events.attendanceCreated(_lectureId, _uri, _topic, msg.sender);
    }

    function mintMentorsSpok(string memory Uri) external {
        Organisation storage org = layoutStorage();

        onlyModerator();
        require(org.spokMinted == false, "spok already minted");
        INFT(org.spokContract).batchMintTokens(org.mentors, Uri);
        org.spokURI = Uri;
        org.spokMinted = true;
    }

    function editTopic(
        bytes memory _lectureId,
        string calldata _topic
    ) external {
        Organisation storage org = layoutStorage();

        if (msg.sender != org.lectureInstance[_lectureId].mentorOnDuty)
            revert Error.not_Autorized_Caller();
        if (org.lectureInstance[_lectureId].attendanceStartTime != 0)
            revert Error.Attendance_compilation_started();
        string memory oldTopic = org.lectureInstance[_lectureId].topic;
        org.lectureInstance[_lectureId].topic = _topic;
        emit Events.topicEditted(_lectureId, oldTopic, _topic);
    }

    function signAttendance(bytes memory _lectureId) external {
        Organisation storage org = layoutStorage();

        onlyStudents();
        if (org.lectureIdUsed[_lectureId] == false)
            revert Error.Invalid_Lecture_Id();
        if (org.lectureInstance[_lectureId].status == false)
            revert Error.Lecture_id_closed();
        if (org.IndividualAttendanceRecord[msg.sender][_lectureId] == true)
            revert Error.Already_Signed_Attendance_For_Id();
        if (org.lectureInstance[_lectureId].attendanceStartTime == 0) {
            org.lectureInstance[_lectureId].attendanceStartTime = block
                .timestamp;
        }
        org.IndividualAttendanceRecord[msg.sender][_lectureId] = true;
        org.studentsTotalAttendance[msg.sender] =
            org.studentsTotalAttendance[msg.sender] +
            1;
        org.lectureInstance[_lectureId].studentsPresent =
            org.lectureInstance[_lectureId].studentsPresent +
            1;
        org.classesAttended[msg.sender].push(_lectureId);

        INFT(org.NftContract).mint(msg.sender, _lectureId, 1);
        emit Events.AttendanceSigned(_lectureId, msg.sender);
    }

    function mentorHandover(address newMentor) external {
        Organisation storage org = layoutStorage();

        if (msg.sender != org.mentorOnDuty && msg.sender != org.moderator)
            revert Error.not_Autorized_Caller();
        org.mentorOnDuty = newMentor;
        emit Events.Handover(msg.sender, newMentor);
    }

    function openAttendance(bytes calldata _lectureId) external {
        Organisation storage org = layoutStorage();

        onlyMentorOnDuty();
        if (org.lectureIdUsed[_lectureId] == false)
            revert Error.Invalid_Lecture_Id();
        if (org.lectureInstance[_lectureId].status == true)
            revert("Attendance already open");
        if (msg.sender != org.lectureInstance[_lectureId].mentorOnDuty)
            revert Error.not_Autorized_Caller();

        org.lectureInstance[_lectureId].status = true;
        emit Events.attendanceOpened(_lectureId, msg.sender);
    }

    function closeAttendance(bytes calldata _lectureId) external {
        Organisation storage org = layoutStorage();

        onlyMentorOnDuty();
        if (org.lectureIdUsed[_lectureId] == false)
            revert Error.Invalid_Lecture_Id();
        if (org.lectureInstance[_lectureId].status == false)
            revert("Attendance already closed");
        if (msg.sender != org.lectureInstance[_lectureId].mentorOnDuty)
            revert Error.not_Autorized_Caller();

        org.lectureInstance[_lectureId].status = false;
        emit Events.attendanceClosed(_lectureId, msg.sender);
    }

    function RecordResults(
        uint256 testId,
        string calldata _resultCid
    ) external {
        Organisation storage org = layoutStorage();

        onlyMentorOnDuty();
        require(org.testIdUsed[testId] == false, "TEST ID ALREADY USED");
        org.testIdUsed[testId] = true;
        org.resultCid.push(_resultCid);
        emit Events.newResultUpdated(testId, msg.sender);
    }

    function EvictStudents(address[] calldata studentsToRevoke) external {
        Organisation storage org = layoutStorage();

        onlyModerator();
        uint studentsToRevokeList = studentsToRevoke.length;
        for (uint i; i < studentsToRevokeList; i++) {
            delete org.studentsData[studentsToRevoke[i]];

            org.students[org.indexInStudentsArray[studentsToRevoke[i]]] = org
                .students[org.students.length - 1];
            org.students.pop();
            org.isStudent[studentsToRevoke[i]] = false;
        }

        IFACTORY(org.organisationFactory).revoke(studentsToRevoke);
        emit Events.studentsEvicted(studentsToRevoke.length);
    }

    function removeMentor(address[] calldata rouge_mentors) external {
        Organisation storage org = layoutStorage();

        onlyModerator();
        uint mentorsRouge = rouge_mentors.length;
        for (uint i; i < mentorsRouge; i++) {
            delete org.mentorsData[rouge_mentors[i]];
            org.mentors[org.indexInMentorsArray[rouge_mentors[i]]] = org
                .mentors[org.mentors.length - 1];
            org.mentors.pop();
            org.isStaff[rouge_mentors[i]] = false;
        }
        IFACTORY(org.organisationFactory).revoke(rouge_mentors);
        emit Events.mentorsRemoved(rouge_mentors.length);
    }

    function getNameArray(
        address[] calldata _students
    ) external view returns (string[] memory) {
        Organisation storage org = layoutStorage();

        string[] memory Names = new string[](_students.length);
        string memory emptyName;
        for (uint i = 0; i < _students.length; i++) {
            if (
                keccak256(
                    abi.encodePacked(org.studentsData[_students[i]]._name)
                ) == keccak256(abi.encodePacked(emptyName))
            ) {
                Names[i] = "UNREGISTERED";
            } else {
                Names[i] = org.studentsData[_students[i]]._name;
            }
        }
        return Names;
    }

    function MintCertificate(string memory Uri) external {
        Organisation storage org = layoutStorage();

        onlyModerator();
        require(org.certificateIssued == false, "certificate already issued");
        INFT(org.certificateContract).batchMintTokens(org.students, Uri);
        org.certiificateURI = Uri;
        org.certificateIssued = true;
    }

    function getStudentAttendanceRatio(
        address _student
    ) external view returns (uint attendace, uint TotalClasses) {
        Organisation storage org = layoutStorage();
        if (org.isStudent[_student] == false) revert Error.not_valid_student();
        attendace = org.studentsTotalAttendance[_student];
        TotalClasses = org.LectureIdCollection.length;
    }

    function listClassesAttended(
        address _student
    ) external view returns (bytes[] memory) {
        Organisation storage org = layoutStorage();

        if (org.isStudent[_student] == false) revert Error.not_valid_student();
        return org.classesAttended[_student];
    }

    function layoutStorage() internal pure returns (Organisation storage org) {
        assembly {
            org.slot := 0
        }
    }
}
