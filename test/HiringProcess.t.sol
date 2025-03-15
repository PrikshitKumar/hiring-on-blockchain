// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {HiringProcess} from "src/Hiring.sol";
import "src/HiringProxy.sol";

contract HiringProcessTest is Test {
    HiringProcess public proxy;
    address public recruiter; 
    address public interviewer; 
    address public applicant;

    function setUp() public {
        recruiter = address(1);
        interviewer = address(2);
        applicant = address(3);

        vm.startPrank(recruiter);

        // Deploy the implementation contract
        HiringProcess implementation = new HiringProcess();
        console.log("HiringProcess Implementation Address:", address(implementation));


        // Deploy the proxy contract pointing to the implementation
        HiringProxy hiringProxyInstance = new HiringProxy(
            address(implementation), 
            recruiter, 
            ""
        );

        proxy = HiringProcess(address(hiringProxyInstance));
        console.log("Hiring Proxy Address: ", address(proxy));

        // Initialize through proxy
        proxy.initialize(recruiter);

        vm.stopPrank();
    }

    function testHiringProcess() public {
        // Job Posting
        vm.startPrank(recruiter);
        proxy.postJob("Software Engineer", "Develop smart contracts");
        (string memory title, string memory description, bool isOpen) = proxy.jobs(1);
        assertEq(title, "Software Engineer");
        assertEq(description, "Develop smart contracts");
        assertEq(isOpen, true);

        // Applicants apply to the job
        vm.startPrank(applicant);
        proxy.applyForJob(1, "Alice", "resumeHash1");
        (string memory name, string memory resumeHash, , bool exists) = proxy.applicants(applicant, 1);
        assertEq(name, "Alice");
        assertEq(resumeHash, "resumeHash1");
        assertTrue(exists);

        // Interviewer started the interviewing process
        vm.startPrank(interviewer);
        proxy.recordInterview(1, applicant, 1, "Good skills", true);
        (uint256 round, string memory feedback, bool passed) = proxy.interviews(1, applicant, 0);
        assertEq(round, 1);
        assertEq(feedback, "Good skills");
        assertTrue(passed);


        // Hire Applicant
        vm.startPrank(recruiter);
        proxy.hireApplicant(1, applicant);
        (, , bool isHired, ) = proxy.applicants(applicant, 1);
        assertTrue(isHired);

        // Close Job 
        proxy.closeJob(1);
        (, , isOpen) = proxy.jobs(1);
        assertEq(isOpen, false, "Job should be closed after calling closeJob");
    }
}
