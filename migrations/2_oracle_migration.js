const safeMath = artifacts.require("SafeMath.sol");
const Oracle = artifacts.require("Oracle.sol");

module.exports = function(deployer) {
    deployer.deploy(safeMath);
    deployer.link(safeMath, Oracle);
    deployer.deploy(Oracle);
};