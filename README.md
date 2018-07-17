# Oracles and Ethereum 
Throughout history man has looked to Oracles as a source of truth and in the blockchain this is no different.  The EVM is a sandbox, meaning everything in the environment is self-contained.   A smart contract cannot call out to an API to grab data.  An oracle is just a provider of data. An oracle gives smart contracts answers to questions about the world. In most cases, without an oracle supplying information, there would be no way for a smart contract to be able to know the things it needs to know in order to do its job.

This tutorial will walk through an implementation of an oracle service http://www.oraclize.it/

## Setting up the project 
	mkdir OracleExample
	cd OracleExample
	truffle init 
	npm init -y
We have just initialized a truffle project.

## Oracle API
We need to copy the oracle api contract found here https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
Copy the whole contract and paste it into a .sol file in your contracts dir.

## Smart contract using Oracle 

### Step 1
We will make a smart contract that tracks the state of Ethereum's price in USD.  Our smart contract will inherit 'usingOraclize' that can be found in the file that we just copied and pasted 

	pragma solidity ^0.4.23;
	import "./OraclizeI.sol";

	contract Ethprice is usingOraclize{
	
	}

### Step 2
We need to make a call to the oracle service by calling 'oraclize_query(datatype, datasource)'.  This function will tell the oracle service to go fetch the data from the datasource that we provide. **This function must be payable** because the Oracle service needs to be paid! It will look for the balance of the contract first but if the contract has no funds then it will look to the msg.value sent with the contract call. 

	pragma solidity ^0.4.23;
	import "./OraclizeI.sol";

	contract Ethprice is usingOraclize{

	string public ETHUSD = "test";

		 function updatePrice() payable {
	            oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?		pair=ETHUSD).result.XETHZUSD.c.0");
	     }
	}

### Step 3 
Overriding the __callback function.  This function is what gets called by the Oracle service to update the state with the data you requested. 

	function __callback(bytes32 myid, string result){
		if (msg.sender != oraclize_cbAddress()) revert();
		ETHUSD = result;
	}
After this function is called by the service the ETHUSD string will be updated in our smart contract.

### Step 4 
Add a migration and copy the truffle.js config file.  Example can be found on the github.

### Step 5 
Deployment 

	truffle migrate --network ropsten
	
Now that the contract is deployed you can call updatePrice() function, remembering to send ETH and the ETHUSD variable will be updated.
