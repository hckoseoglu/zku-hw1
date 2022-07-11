const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/

const verifierRegex = /contract Verifier/

let content = fs.readFileSync("./contracts/HelloWorldVerifier.sol", { encoding: 'utf-8' });
let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumped = bumped.replace(verifierRegex, 'contract HelloWorldVerifier');

fs.writeFileSync("./contracts/HelloWorldVerifier.sol", bumped);

// [assignment] add your own scripts below to modify the other verifier contracts you will build during the assignment

let multiplierGroth16 = fs.readFileSync("./contracts/Multiplier3.sol", { encoding: 'utf-8' });
let bumped2 = multiplierGroth16.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumped2 = bumped2.replace(verifierRegex, 'contract MultiplierVerifier');
fs.writeFileSync("./contracts/Multiplier3.sol", bumped2);

let multiplierPlonk = fs.readFileSync("./contracts/Multiplier3_plonk.sol", { encoding: 'utf-8' });
let bumped3 = multiplierPlonk.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumped3 = bumped3.replace(verifierRegex, 'contract Multiplier_plonkVerifier');
fs.writeFileSync("./contracts/Multiplier3_plonk.sol", bumped3);