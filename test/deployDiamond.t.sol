// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.0;

// import "../contracts/interfaces/IDiamondCut.sol";
// import "../contracts/facets/DiamondCutFacet.sol";
// import "../contracts/facets/DiamondLoupeFacet.sol";
// import "../contracts/facets/OwnershipFacet.sol";

// // import "../contracts/facets/LayoutChangerFacet.sol";
// // import "../contracts/facets/LayoutChangerFacetFactory.sol";
// // import "../contracts/facets/organisationFacet.sol";
// import "../contracts/interfaces/Ichild.sol";
// import "../contracts/interfaces/IFactory.sol";
// import "../contracts/facets/OrganisationFactoryFacet.sol";

// import "forge-std/Test.sol";
// import "../contracts/Diamond.sol";

// import "../contracts/certificates/certificateFactory.sol";
// import "../contracts/libraries/LibOrgFactory.sol";
// import "../contracts/libraries/LibAppStorage.sol";

// contract DiamondDeployer is Test, IDiamondCut {
//     //contract types of facets to be deployed
//     LibAppStorage.Organisation internal orgFacet;
//     Diamond diamond;
//     DiamondCutFacet dCutFacet;
//     DiamondLoupeFacet dLoupe;
//     OwnershipFacet ownerF;
//     // LayoutChangerFacetFactory lFacetFactory;
//     certificateFactory _certificateFactory;

//     OrganisationFactoryFacet orgFacetFactory;

//     // LayoutChangerFacet lFacet;
//     // organisationFactory orgFacetFactory;

//     Individual student1;
//     Individual[] students;
//     Individual[] editstudents;

//     Individual mentor;
//     Individual[] mentors;
//     Individual[] editMentors;
//     address[] studentsToEvict;
//     address[] rogue_mentors;
//     address[] nameCheck;
//     address mentorAdd = 0xfd182E53C17BD167ABa87592C5ef6414D25bb9B4;
//     address studentAdd = 0x13B109506Ab1b120C82D0d342c5E64401a5B6381;
//     address director = 0xA771E1625DD4FAa2Ff0a41FA119Eb9644c9A46C8;
//     address public organisationAddress;

//     function setUp() public {
//         //deploy facets
//         dCutFacet = new DiamondCutFacet();
//         diamond = new Diamond(address(this), address(dCutFacet));
//         dLoupe = new DiamondLoupeFacet();
//         ownerF = new OwnershipFacet();
//         _certificateFactory = new certificateFactory();
//         orgFacetFactory = new OrganisationFactoryFacet();

//         // vm.prank(director);
//         student1._address = address(studentAdd);
//         student1._name = "JOHN DOE";
//         students.push(student1);

//         mentor._address = address(mentorAdd);
//         mentor._name = "MR. ABIMS";
//         mentors.push(mentor);
//         // //upgrade diamond with facets

//         //build cut struct
//         FacetCut[] memory cut = new FacetCut[](4);

//         cut[0] = (
//             FacetCut({
//                 facetAddress: address(dLoupe),
//                 action: FacetCutAction.Add,
//                 functionSelectors: generateSelectors("DiamondLoupeFacet")
//             })
//         );

//         cut[1] = (
//             FacetCut({
//                 facetAddress: address(ownerF),
//                 action: FacetCutAction.Add,
//                 functionSelectors: generateSelectors("OwnershipFacet")
//             })
//         );
//         cut[2] = (
//             FacetCut({
//                 facetAddress: address(orgFacetFactory),
//                 action: FacetCutAction.Add,
//                 functionSelectors: generateSelectors("OrganisationFactoryFacet")
//             })
//         );

//         cut[3] = (
//             FacetCut({
//                 facetAddress: address(_certificateFactory),
//                 action: FacetCutAction.Add,
//                 functionSelectors: generateSelectors("certificateFactory")
//             })
//         );

//         //upgrade diamond
//         IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");

//         //call a function
//         DiamondLoupeFacet(address(diamond)).facetAddresses();
//         OrganisationFactoryFacet(address(diamond));
//         // Organisation(address(diamond));

//         certificateFactory(address(diamond));
//     }

//     function testOrgFactoryCreation() public {
//         orgFacetFactory = OrganisationFactoryFacet(address(diamond));
//         vm.startPrank(director);
//         (
//             address Organisation,
//             address OrganisationNft,
//             address OrganisationMentorSpok,
//             address OrganizationCert
//         ) = orgFacetFactory.createorganisation(
//                 "WEB3BRIDGE",
//                 "COHORT 9",
//                 "http://test.org",
//                 "Abims"
//             );

//         address child = orgFacetFactory.getUserOrganisatons(director)[0];

//         bool status = ICHILD(child).getOrganizationStatus();
//         assertEq(status, true);
//         organisationAddress = Organisation;
//         vm.stopPrank();
//         assertEq(Organisation, organisationAddress);
//     }

//     // function testStudentRegister() public {
//     //     testOrgFactoryCreation();
//     //     vm.startPrank(director);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];

//     //     ICHILD(child).registerStudents(students);
//     //     address[] memory studentsList = ICHILD(child).liststudents();
//     //     bool studentStatus = ICHILD(child).VerifyStudent(studentAdd);
//     //     string memory studentName = ICHILD(child).getStudentName(studentAdd);
//     //     assertEq(1, studentsList.length);
//     //     assertEq(true, studentStatus);
//     //     assertEq("JOHN DOE", studentName);
//     //     vm.stopPrank();
//     // }

//     // function testGetStudentsNamesArray() public {
//     //     testStudentRegister();
//     //     nameCheck.push(studentAdd);
//     //     nameCheck.push(mentorAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     string[] memory studentsName = ICHILD(child).getNameArray(nameCheck);
//     //     assertEq(studentsName[0], "JOHN DOE");
//     //     assertEq(studentsName[1], "UNREGISTERED");
//     //     console.log(studentsName[0]);
//     //     console.log(studentsName[1]);
//     // }

//     // function testZ_edit_students_Name() public {
//     //     testStudentRegister();
//     //     vm.startPrank(studentAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(studentAdd)[0];

//     //     ICHILD(child).RequestNameCorrection();

//     //     vm.stopPrank();

//     //     student1._name = "MUSAA";
//     //     student1._address = studentAdd;
//     //     editstudents.push(student1);

//     //     vm.startPrank(director);

//     //     ICHILD(child).editStudentName(editstudents);

//     //     string memory newStudentName = ICHILD(child).getStudentName(studentAdd);

//     //     console.log(newStudentName);

//     //     assertEq("MUSAA", newStudentName);
//     // }

//     // function testMentorRegister() public {
//     //     testOrgFactoryCreation();
//     //     vm.startPrank(director);

//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];

//     //     ICHILD(child).registerStaffs(mentors);
//     //     address[] memory studentsList = ICHILD(child).listMentors();

//     //     bool mentorStatus = ICHILD(child).VerifyMentor(mentorAdd);
//     //     string memory mentorName = ICHILD(child).getMentorsName(mentorAdd);

//     //     assertEq(2, studentsList.length);
//     //     assertEq(true, mentorStatus);
//     //     assertEq("MR. ABIMS", mentorName);
//     // }

//     // function testZ_edit_mentors_Name() public {
//     //     testMentorRegister();
//     //     vm.startPrank(mentorAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(mentorAdd)[0];

//     //     ICHILD(child).RequestNameCorrection();

//     //     vm.stopPrank();

//     //     mentor._name = "Mr. Abimbola";
//     //     mentor._address = mentorAdd;

//     //     editMentors.push(mentor);

//     //     vm.startPrank(director);

//     //     ICHILD(child).editMentorsName(editMentors);

//     //     string memory newMentorsName = ICHILD(child).getMentorsName(mentorAdd);

//     //     console.log(newMentorsName);

//     //     assertEq("Mr. Abimbola", newMentorsName);
//     // }

//     // function testFail_MentorIsNotOnDuty() public {
//     //     testMentorRegister();
//     //     vm.startPrank(mentorAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];

//     //     ICHILD(child).createAttendance(
//     //         "B0202",
//     //         "http://test.org",
//     //         "INTRODUCTION TO BLOCKCHAIN"
//     //     );

//     //     vm.stopPrank();
//     // }

//     // function testMentorHandOver() public {
//     //     testStudentRegister();
//     //     vm.startPrank(director);

//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     address mentorOnDuty1 = ICHILD(child).getMentorOnDuty();
//     //     ICHILD(child).mentorHandover(mentorAdd);
//     //     address mentorOnDuty = ICHILD(child).getMentorOnDuty();

//     //     assertEq(mentorOnDuty1, director);
//     //     assertEq(mentorOnDuty, mentorAdd);
//     //     vm.stopPrank();
//     // }

//     // function testCreateAttendance() public {
//     //     testMentorHandOver();
//     //     vm.startPrank(mentorAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];

//     //     ICHILD(child).createAttendance(
//     //         "B0202",
//     //         "http://test.org",
//     //         "INTRODUCTION TO BLOCKCHAIN"
//     //     );

//     //     vm.stopPrank();
//     // }

//     // function testGetStudentPresent() public {
//     //     testOrgFactoryCreation();
//     //     address child = organisationAddress;

//     //     bytes memory lectureId = "B0202";
//     //     testSignAttendance();
//     //     uint studentsPresent = ICHILD(child).getStudentsPresent(lectureId);
//     //     assertEq(studentsPresent, 1);
//     // }

//     // function testFail_TakeAttendaceBeforeClass() public {
//     //     testCreateAttendance();
//     //     vm.startPrank(studentAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];

//     //     ICHILD(child).signAttendance("B0202");
//     //     vm.stopPrank();
//     // }

//     // function testFail_StudentOpenAttendace() public {
//     //     testCreateAttendance();
//     //     vm.startPrank(studentAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     ICHILD(child).openAttendance("B0202");
//     //     vm.stopPrank();
//     // }

//     // function testFail_StudentSignWrongAttendance() public {
//     //     testCreateAttendance();
//     //     vm.startPrank(mentorAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     ICHILD(child).openAttendance("B0202");
//     //     vm.stopPrank();
//     //     vm.startPrank(studentAdd);
//     //     ICHILD(child).signAttendance("B0205");
//     // }

//     // function testSignAttendance() public {
//     //     testCreateAttendance();
//     //     vm.startPrank(mentorAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     ICHILD(child).openAttendance("B0202");
//     //     vm.stopPrank();

//     //     vm.startPrank(studentAdd);
//     //     ICHILD(child).signAttendance("B0202");
//     //     vm.stopPrank();
//     // }

//     // function testStudentsAttendanceData() public {
//     //     testSignAttendance();
//     //     vm.startPrank(mentorAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     (uint attendace, uint totalClasses) = ICHILD(child)
//     //         .getStudentAttendanceRatio(studentAdd);

//     //     uint[] memory lectures = ICHILD(child).getLectureIds();
//     //     ICHILD.lectureData memory lectureData = ICHILD(child).getLectureData(
//     //         "B0202"
//     //     );

//     //     assertEq(attendace, totalClasses);
//     //     assertEq(lectures.length, 1);
//     //     // assertEq(lectures[0], "B0202");
//     //     assertEq(lectureData.topic, "INTRODUCTION TO BLOCKCHAIN");
//     //     assertEq(lectureData.mentorOnDuty, mentorAdd);
//     //     assertEq(lectureData.uri, "http://test.org");
//     //     assertEq(lectureData.attendanceStartTime, 1);
//     //     assertEq(lectureData.studentsPresent, 1);
//     //     assertEq(lectureData.status, true);
//     // }

//     // function testEvictStudent() public {
//     //     testSignAttendance();
//     //     vm.startPrank(director);
//     //     studentsToEvict.push(studentAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     ICHILD(child).EvictStudents(studentsToEvict);

//     //     address[] memory studentsList = ICHILD(child).liststudents();
//     //     address[] memory studentOrganizations = orgFacetFactory
//     //         .getUserOrganisatons(studentAdd);
//     //     bool studentStatus = ICHILD(child).VerifyStudent(studentAdd);
//     //     assertEq(0, studentOrganizations.length);
//     //     assertEq(0, studentsList.length);
//     //     assertEq(false, studentStatus);
//     // }

//     // function testRemoveMentor() public {
//     //     testMentorRegister();
//     //     vm.startPrank(director);
//     //     rogue_mentors.push(mentorAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     ICHILD(child).removeMentor(rogue_mentors);

//     //     address[] memory mentorsList = ICHILD(child).listMentors();
//     //     address[] memory mentorsOrganizations = orgFacetFactory
//     //         .getUserOrganisatons(mentorAdd);
//     //     bool status = ICHILD(child).VerifyMentor(mentorAdd);
//     //     assertEq(0, mentorsOrganizations.length);
//     //     assertEq(1, mentorsList.length);
//     //     assertEq(false, status);
//     // }

//     // function testFail_EvictedStudentSignAttendance() public {
//     //     testEvictStudent();
//     //     vm.startPrank(mentorAdd);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];

//     //     ICHILD(child).createAttendance(
//     //         "B0202",
//     //         "http://test.org",
//     //         "BLOCKCHAIN TRILEMA"
//     //     );
//     //     ICHILD(child).openAttendance("B0202");
//     //     vm.stopPrank();

//     //     vm.startPrank(studentAdd);
//     //     ICHILD(child).signAttendance("B0202");
//     //     vm.stopPrank();
//     // }

//     // function testCertificateIssuance() public {
//     //     testSignAttendance();
//     //     vm.startPrank(director);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     ICHILD(child).MintCertificate("http://test.org");
//     // }

//     // function testMentorsSpok() public {
//     //     testSignAttendance();
//     //     vm.startPrank(director);
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];
//     //     ICHILD(child).mintMentorsSpok("http://test.org");
//     // }

//     // function testToggleOrganizationStatus() public {
//     //     testOrgFactoryCreation();
//     //     address child = orgFacetFactory.getUserOrganisatons(director)[0];

//     //     ICHILD(child).toggleOrganizationStatus();

//     //     // Now, the status should be false
//     //     bool toggledStatus = ICHILD(child).getOrganizationStatus();
//     //     assertEq(toggledStatus, false);

//     //     // Toggle the status to true
//     //     ICHILD(child).toggleOrganizationStatus();

//     //     bool finalStatus = ICHILD(child).getOrganizationStatus();
//     //     assertEq(finalStatus, true);
//     // }

//     // function testGetOrg() public {
//     //     testLayoutfacetCreation();
//     //     LayoutChangerFacetFactory l = LayoutChangerFacetFactory(
//     //         address(diamond)
//     //     );
//     //     l.getOrganizations();
//     // }

//     // function testLayoutfacet2() public {
//     //     LayoutChangerFacet l = LayoutChangerFacet(address(diamond));
//     //     //check outputs
//     //     l.ChangeNameAndNo(uint256(777), "lol");
//     //     LibAppStorage.Layout memory la = l.getLayout();

//     //     assertEq(la.name, "lol");
//     //     assertEq(la.currentNo, 777);
//     // }

//     function generateSelectors(
//         string memory _facetName
//     ) internal returns (bytes4[] memory selectors) {
//         string[] memory cmd = new string[](3);
//         cmd[0] = "node";
//         cmd[1] = "scripts/genSelectors.js";
//         cmd[2] = _facetName;
//         bytes memory res = vm.ffi(cmd);
//         selectors = abi.decode(res, (bytes4[]));
//     }

//     function diamondCut(
//         FacetCut[] calldata _diamondCut,
//         address _init,
//         bytes calldata _calldata
//     ) external override {}
// }
