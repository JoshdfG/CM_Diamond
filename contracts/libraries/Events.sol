// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Events {
    // EVENTS
    event staffsRegistered(uint noOfStaffs);
    event nameChangeRequested(address changer);
    event StaffNamesChanged(uint noOfStaffs);
    event studentsRegistered(uint noOfStudents);
    event studentNamesChanged(uint noOfStudents);
    event attendanceCreated(
        bytes indexed lectureId,
        string indexed uri,
        string topic,
        address indexed staff
    );
    event topicEditted(bytes Id, string oldTopic, string newTopic);
    event AttendanceSigned(bytes Id, address signer);
    event Handover(address oldMentor, address newMentor);
    event attendanceOpened(bytes Id, address mentor);
    event attendanceClosed(bytes Id, address mentor);
    event studentsEvicted(uint noOfStudents);
    event mentorsRemoved(uint noOfStaffs);
    event newResultUpdated(uint256 testId, address mentor);
}
