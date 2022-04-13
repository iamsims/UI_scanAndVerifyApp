const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');

const contractCompile = require('./build/UserFactory.json');

const provider = new HDWalletProvider(
    `vacant vessel column hurdle hungry napkin problem wagon nut never matrix cement`,
    `https://rinkeby.infura.io/v3/11b5da3171f94a138ac566452555eba7`
);

const web3 = new Web3(provider);

const deploy = async () => {
   
    const accounts = await web3.eth.getAccounts();
    console.log(accounts);
    console.log("Attempting to deploy from account",accounts[0]);
    const result = await new web3.eth.Contract(contractCompile.abi)
                .deploy({data: contractCompile.evm.bytecode.object})
                .send({gas:'10000000', from:accounts[0]});

    console.log('Contract deployed to ', result.options.address);
    provider.engine.stop();
};

deploy();