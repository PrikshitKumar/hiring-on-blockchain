// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HiringStorage {
    struct Job {
        string title;
        string description;
        bool isOpen;
    }

    struct Applicant {
        uint256 jobId;
        string name;
        string resumeHash;
        bool exists;
    }

    struct Interview {
        uint256 round;
        string feedback;
        bool passed;
    }

    uint256 public jobCounter;
    uint256 public totalApplicants;
    mapping(uint256 => Job) public jobs;
    mapping(address => Applicant) public applicants;
    mapping(address => mapping(uint256 => bool)) public hasApplied; 
    mapping(uint256 => mapping(address => Interview[])) public interviews;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     */
    uint256[49] private __gap;
}