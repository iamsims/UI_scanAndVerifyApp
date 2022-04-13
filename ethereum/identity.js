import web3 from './web3';

const Identity = require('./build/Identity.json');

export default (address) => {
    return new web3.eth.Contract(
        Identity.abi,
        address
    );
};