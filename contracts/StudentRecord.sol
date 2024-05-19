// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract StudentRecord {
    // Struct to represent a student record
    struct Student {
        uint256 id;
        string name;
        uint256 age;
        string department;
        bool exists;
    }

    // Mapping to store student records
    mapping(uint256 => Student) private students;

    // Used to store all the keys
    uint256[] public keys;

    // Event to emit when a new student record is added
    event StudentAdded(uint256 indexed id, string name, uint256 age, string department);

    // Event to emit when a student record is updated
    event StudentUpdated(uint256 indexed id, string name, uint256 age, string department);

    // Event to emit when a student record is deleted
    event StudentDeleted(uint256 indexed id);

    // Modifier to restrict access to certain functions
    modifier onlyAdmin() {
        require(msg.sender == owner, "Only admin can perform this action");
        _;
    }

    // Address of the contract owner (admin)
    address public owner;

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to add a new student record
    function addStudent(uint256 _id, string memory _name, uint256 _age, string memory _department) public onlyAdmin {
        require(_id != 0, "Invalid ID");
        require(!students[_id].exists, "Student with the given ID already exists");

        students[_id] = Student(_id, _name, _age, _department, true);
        keys.push(_id);
        emit StudentAdded(_id, _name, _age, _department);
    }

    // Function to update an existing student record
    function updateStudent(uint256 _id, string memory _name, uint256 _age, string memory _department) public onlyAdmin {
        require(_id != 0, "Invalid ID");
        require(students[_id].exists, "Student with the given ID does not exist");

        students[_id].name = _name;
        students[_id].age = _age;
        students[_id].department = _department;
        emit StudentUpdated(_id, _name, _age, _department);
    }

    // Function to retrieve a student record
    function getStudent(uint256 _id) public view returns (uint256, string memory, uint256, string memory) {
        require(_id != 0, "Invalid ID");
        require(students[_id].exists, "Student with the given ID does not exist");

        Student memory student = students[_id];
        return (student.id, student.name, student.age, student.department);
    }

    // Function to delete a student record
    function deleteStudent(uint256 _id) public onlyAdmin {
        require(_id != 0, "Invalid ID");
        require(students[_id].exists, "Student with the given ID does not exist");

        delete students[_id];
        for (uint i = 0; i < keys.length; i++) {
            if (keys[i] == _id) {
                // Swap the key with the last element
                keys[i] = keys[keys.length - 1];
                // Remove the last element
                keys.pop();
                break;
            }
        }
        emit StudentDeleted(_id);
    }

    // Get all student records
    function getAll() public view returns (Student[] memory) {
        Student[] memory values = new Student[](keys.length);
        for (uint i = 0; i < keys.length; i++) {
            values[i] = students[keys[i]];
        }
        return values;
    }

    // Function to check if a student record exists
    function studentExists(uint256 _id) public view returns (bool) {
        return students[_id].exists;
    }
}
