// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HiringProcess is Ownable, HiringProcessStorage {
    event JobPosted(uint256 jobId, string title);
    event ApplicantApplied(uint256 totalApplicants, uint256 jobId, address applicant, bool applied);
    event InterviewRecorded(uint256 jobId, address applicantAddress, uint256 round, string feedback, bool passed);

    function postJob(string memory _title, string memory _description) public onlyOwner {
        jobCounter++;
        jobs[jobCounter] = Job(_title, _description, true);
        emit JobPosted(jobCounter, _title);
    }

    function applyForJob(uint256 _jobId, string memory _name, string memory _resumeHash) public {
        require(jobs[_jobId].isOpen, "No longer taking the applications");
        require(!hasApplied[msg.sender][_jobId], "You have already applied for this job");
        
        totalApplicants++;
        applicants[msg.sender] = Applicant(_jobId, msg.sender, _name, _resumeHash, true);
        hasApplied[msg.sender][_jobId] = true;
        
        emit ApplicantApplied(totalApplicants, _jobId, msg.sender, hasApplied[msg.sender][_jobId]);
    }

    function recordInterview(uint256 _jobId, uint256 _applicantAddress, uint256 _round, string memory _feedback, bool _passed) public onlyOwner {
        require(applicants[_applicantAddress].exists, "Applicant does not exist");
        interviews[_jobId][_applicantAddress].push(Interview(_round, _feedback, _passed));
        emit InterviewRecorded(_jobId, _applicantAddress, _round, _feedback, _passed);
    }

    function closeJob(uint256 _jobId) public onlyOwner {
        require(jobs[_jobId].isOpen, "Job is already closed");
        jobs[_jobId].isOpen = false;

        emit JobClosed(_jobId);
    }
}
