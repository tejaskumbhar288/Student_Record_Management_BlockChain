const StudentRecord = artifacts.require("StudentRecord");

module.exports = function(deployer) {
  deployer.deploy(StudentRecord);
};
