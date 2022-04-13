const path = require("path");
const fs = require("fs-extra");
const solc = require("solc");

const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

const contractPath = path.resolve(__dirname, "contracts", "Identity.sol");
const source = fs.readFileSync(contractPath, "utf8");
const input = {
    language: 'Solidity',
    sources: {
        'Identity.sol': {
            content: source,
        },
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['*'],
            },
        },
    },
};

output = JSON.parse(solc.compile(JSON.stringify(input))).contracts["Identity.sol"];
// console.log(output);

fs.ensureDirSync(buildPath);

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.replace(':', '') + '.json'),
    output[contract]
  );
}

module.exports = output;
//console.log(output.abi);