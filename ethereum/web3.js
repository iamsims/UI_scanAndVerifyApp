import Web3 from "web3";

let web3;

if (typeof window != 'undefined' && window.web3 !== 'undefined') {
    //We are in the browser and running the metamsk
    web3 = new Web3(window.ethereum);
    console.log("here");
}
else {
    //We are in the server or user is not running the metamask
    const provider = new Web3.providers.HttpProvider(
        'https://rinkeby.infura.io/v3/11b5da3171f94a138ac566452555eba7'
    );
    web3 = new Web3(provider);
    console.log("there");
}

export default web3;