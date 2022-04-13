import web3 from './web3';

const UserFactory = require('./build/UserFactory.json');

// console.log(UserFactory.abi);

const Factory = new web3.eth.Contract(
    UserFactory.abi,
    '0x03138D8a09D9156A94E5BFbeD842E224FbEDA12c'
);

export default Factory;