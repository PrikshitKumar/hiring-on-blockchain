// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HiringStorage {
    struct Job {
        string title;
        string description;
        bool isOpen;
    }

    struct Applicant {
        string name;
        string resumeHash;
        bool isHired;
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
    mapping(address => mapping(uint256 => Applicant)) public applicants;
    mapping(address => mapping(uint256 => bool)) public hasApplied; 
    mapping(uint256 => mapping(address => Interview[])) public interviews;

    uint256[50] private __gap;
}