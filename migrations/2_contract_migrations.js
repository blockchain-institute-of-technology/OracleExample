var ETHprice = artifacts.require("./ETHprice.sol");

module.exports = function(deployer) {
  deployer.deploy(ETHprice,{value:web3.toWei(1, 'ether')});
};
