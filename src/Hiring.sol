// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {HiringStorage} from "./HiringStorage.sol";

contract HiringProcess is Initializable, OwnableUpgradeable, HiringStorage {
    event JobPosted(uint256 jobId, string title);
    event ApplicantApplied(uint256 totalApplicants, uint256 jobId, address applicant, bool applied);
    event InterviewRecorded(uint256 jobId, address applicantAddress, uint256 round, string feedback, bool passed);
    event JobClosed(uint256 jobId);
    event ApplicantHired(uint256 jobId, address applicant);

    function initialize(address _initialOwner) public initializer {
        __Ownable_init(_initialOwner);
    }

    function postJob(string memory _title, string memory _description) public onlyOwner {
        jobCounter++;
        jobs[jobCounter] = Job(_title, _description, true);
        emit JobPosted(jobCounter, _title);
    }

    function applyForJob(uint256 _jobId, string memory _name, string memory _resumeHash) public {
        require(jobs[_jobId].isOpen, "No longer taking the applications");
        require(!hasApplied[msg.sender][_jobId], "You have already applied for this job");
        
        totalApplicants++;
        applicants[msg.sender][_jobId] = Applicant(_name, _resumeHash, false, true);
        hasApplied[msg.sender][_jobId] = true;
        
        emit ApplicantApplied(totalApplicants, _jobId, msg.sender, hasApplied[msg.sender][_jobId]);
    }

    function recordInterview(uint256 _jobId, address _applicantAddress, uint256 _round, string memory _feedback, bool _passed) public onlyOwner {
        require(applicants[_applicantAddress][_jobId].exists, "Applicant does not exist");
        require(!applicants[_applicantAddress][_jobId].isHired, "Applicant is already hired");

        interviews[_jobId][_applicantAddress].push(Interview(_round, _feedback, _passed));
        emit InterviewRecorded(_jobId, _applicantAddress, _round, _feedback, _passed);
    }

    function hireApplicant(uint256 _jobId, address _applicantAddress) public onlyOwner {
        require(applicants[_applicantAddress][_jobId].exists, "Applicant does not exist");
        require(!applicants[_applicantAddress][_jobId].isHired, "Applicant is already hired");

        bool hasPassed = false;
        for (uint i = 0; i < interviews[_jobId][_applicantAddress].length; i++) {
            if (interviews[_jobId][_applicantAddress][i].passed) {
                hasPassed = true;
                break;
            }
        }

        require(hasPassed, "Applicant has not passed any interview");
        applicants[_applicantAddress][_jobId].isHired = true;
        emit ApplicantHired(_jobId, _applicantAddress);
    }


    function closeJob(uint256 _jobId) public onlyOwner {
        require(jobs[_jobId].isOpen, "Job is already closed");
        jobs[_jobId].isOpen = false;
        emit JobClosed(_jobId);
    }
}
