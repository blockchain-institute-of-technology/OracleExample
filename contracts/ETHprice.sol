pragma solidity ^0.4.23;
import "./OraclizeI.sol";

contract Ethprice is usingOraclize{

	string public ETHUSD = "test";

	event ETHUSDUpdated(uint _time, string _newprice, uint gasLeft);
	event LowGasWarning(uint _remainingGas, uint estimateRemainingTime);
	
	constructor() payable {
		oraclize_query(3000, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
	}

	 function updatePrice() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            //LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            //LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query(60, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
        }
    }

	function __callback(bytes32 myid, string result){
		if (msg.sender != oraclize_cbAddress()) revert();
		if(oraclize_getPrice("URL")*288 > this.balance){
			LowGasWarning(this.balance, day);
		}
			
		ETHUSD = result;
        ETHUSDUpdated(now,result, this.balance);
	}

}