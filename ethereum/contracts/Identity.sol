// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Recovery {
    address uuid;
    address[] contacts;
    mapping(address => address) recoveries;
    mapping(address => uint) proposed_keys;

    modifier onlyUuid(){
        if (msg.sender == uuid)
            _;
    }
    modifier onlyContact(){
        for(uint i = 0; i < contacts.length; i++)
            if(contacts[i] == msg.sender)
                _;
    }

    constructor(address _uuid) {
        uuid = _uuid;
    }
    function setContacts(address[] memory _contacts) onlyUuid public {
        contacts = _contacts;
    }
    function getContacts() public view returns (address[] memory _contacts){
        _contacts = contacts;
    }
    function addRecovery(address _key) onlyContact public{
        if(recoveries[msg.sender] != _key 
            && proposed_keys[recoveries[msg.sender]] == 0){
            recoveries[msg.sender] = _key;
            proposed_keys[_key] += 1;
        }
        if (proposed_keys[_key] >= (contacts.length / 2)){
            Identity identity_c = Identity(uuid);
            proposed_keys[_key] = 0;
            identity_c.transferOwner(_key);
        }
    }
    function getRecoveries(address _key) public view
            returns (uint num_done, uint num_total) {
        num_done = proposed_keys[_key];
        num_total = contacts.length / 2;
    }
}

contract Identity {
    address owner;
    string ipfs_hash;
    address recovery;

    modifier onlyOwner(){
        if (msg.sender == owner)
            _;
    }
    modifier onlyOwnerOrRecovery(){
        if (msg.sender == owner || msg.sender == recovery)
            _;
    }

    constructor(address user) {
        owner = user;
        recovery = address(new Recovery(address(this)));
    }
    function setRecovery(address _recovery) onlyOwner public {
        recovery = _recovery;
    }
    function setIPFSHash(string memory _ipfs_hash) onlyOwner public {
        ipfs_hash = _ipfs_hash;
    }
    function setContacts(address[] memory _contacts) onlyOwner public {
        Recovery recovery_c = Recovery(recovery);
        recovery_c.setContacts(_contacts);
    }
    function addRecovery(address _recovery, address _key) onlyOwner public {
        Recovery recovery_c = Recovery(_recovery);
        recovery_c.addRecovery(_key);
    }
    function transferOwner(address _owner) onlyOwnerOrRecovery public {
        owner = _owner;
    }
    function getDetails() public view returns 
            (address _owner, string memory _ipfs_hash, address _recovery) {
        _owner = owner;
        _ipfs_hash = ipfs_hash;
        _recovery = recovery;
    }

}

contract UserFactory {
    address[] public deployedUser;
    mapping(address => address) specificUserContractAddress;

    function createUser() public {
        address newUser = address (new Identity(msg.sender));
        deployedUser.push(msg.sender);
        specificUserContractAddress[msg.sender] = newUser;
    }

    function getDeployedUser() public view returns (address[] memory) {
        return deployedUser;
    }

    function getUserContractAddress() public view returns (address) {
        return specificUserContractAddress[msg.sender];
    }
}