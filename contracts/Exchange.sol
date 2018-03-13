pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import './GreenToken.sol';

contract Exchange {
	struct Generator {
		string generatorId;
		string generatorName;
		uint capacity;
		uint generated;
		uint tokensAvailable;
	}

	struct Buyer {
		string buyerId;
		string buyerName;
		uint tokensNeeded;
	}

	struct Utility {
		string utilId;	
		string utilName;
		uint currentRate;
	}

	struct Resident {
		string residentId;
		string residentName;
		uint energyAvailable;
		uint energyNeeded;
	}

	struct Bid {
		uint price;
		uint amount;
	}

	// This will be the address of your deployed greenToken
	address GreenTokenAddress = 0xd37e91f5a282036a28f5e78963edddf26462a23a;
	address public owner;
	mapping (string => address) generatorIdToAddress;
	mapping (string => address) buyerIdToAddress;
	mapping (string => address) utilityIdToAddress;
	mapping (string => address) residentIdToAddress;
	mapping (string => Bid) bidsToBuy;
	mapping (string => Bid) bidsToSell;

	Generator [] generators;
	Buyer [] public buyers;
	Utility [] public utilities;
	Resident [] public residents;

	// Have hardcoded everything here. You would use registerGenerator and similar methods to create these
	Generator g1 = Generator("G1", "RE Infra Limited", 1000, 400, 400);
	Generator g2 = Generator("G2", "Green energy Limited", 2000, 1200, 1200);
	Generator g3 = Generator("G3", "Green Corridor Limited", 1500, 800, 800);
	Buyer b1 = Buyer("B1", "Financial Solutions Limited", 400);
	Buyer b2 = Buyer("B2", "CSR corporate Limited", 200);
	Buyer b3 = Buyer("B3", "Infotech Limited", 300);
	Utility u1 = Utility("U1", "Reliance Energy", 50);
	Utility u2 = Utility("U2", "Tata Powers", 51);
	Utility u3 = Utility("U3", "BEST", 48);
	Resident r1 = Resident("R1", "Amit Gupta", 0, 20);
	Resident r2 = Resident("R2", "Raj Sharma", 50, 0);
	Resident r3 = Resident("R3", "Mohini Jadhav", 0, 10);

	function Exchange() public {
		owner = msg.sender;
		// Again, hardcoded stuff
		generators.push(g1);
		generators.push(g2);
		generators.push(g3);
		buyers.push(b1);
		buyers.push(b2);
		buyers.push(b3);
		utilities.push(u1);
		utilities.push(u2);
		utilities.push(u3);
		residents.push(r1);
		residents.push(r2);
		residents.push(r3);
		// hardcoding addresses here. 
		address a1 = 0xbaa7b4b89827a1b3040749864f8d20f119822e87;
		address a2 = 0x8cbdd4b82a2cb740967e40a5e6d9c85bd2208b4e;
		address a3 = 0x5c5b33c4bca87667b2b2c03bfc84dedcae417f4c;
		address a4 = 0xb0751758381bff3ad0e720b218276d32edbd0834;
		generatorIdToAddress["G1"] = a1;
		generatorIdToAddress["G2"] = a1;
		generatorIdToAddress["G3"] = a1;
		buyerIdToAddress["B1"] = a2;
		buyerIdToAddress["B2"] = a2;
		buyerIdToAddress["B3"] = a2;
		utilityIdToAddress["U1"] = a3;
		utilityIdToAddress["U2"] = a3;
		utilityIdToAddress["U3"] = a3;
		residentIdToAddress["R1"] = a4;
		residentIdToAddress["R2"] = a4;
		residentIdToAddress["R3"] = a4;
	}

	// You need to create similar registerBuyer, registerUtility and registerResident methods
	function registerGenerator(string uid, string name, uint capacity) public {
		require(generatorIdToAddress[uid]==0);
		StandardToken greenToken = StandardToken(GreenTokenAddress);
		uint balance = greenToken.balanceOf(msg.sender);
		Generator memory g1 = Generator(uid, name, capacity, balance, balance);
		generators.push(g1);
		generatorIdToAddress[uid] = msg.sender;
	}

	function acceptBidsToBuy(string buyerId, uint price, uint amount) public payable {
		require(buyerIdToAddress[buyerId]==msg.sender);
		// The buyer needs to send the amount of ether that is equal to his bid * numberOfTokensRequired
		// The balances are returned to the bidder after the double auction is over
		// This is a hack and there are better ways of doing this 
		require(msg.value>=price*amount);
		Bid memory b = Bid(price, amount);
		bidsToBuy[buyerId] = b;
	}
	
	function acceptBidsToSell(string sellerId, uint price, uint amount) public {
		require(generatorIdToAddress[sellerId]==msg.sender);
		Bid memory b = Bid(price, amount);
		bidsToSell[sellerId] = b;
	}

	function addressToAddress (address from, address to, uint amount) private {
		StandardToken greenToken = StandardToken(GreenTokenAddress);
		greenToken.transferFrom(from, to, amount);
	}
	

	function generatorToUtility(string generatorId, string utilId, uint amount) public {
		// Not making any checks
		addressToAddress(generatorIdToAddress[generatorId], utilityIdToAddress[utilId], amount);
	}

	function residentToResident(string fromResidentId, string toResidentId, uint energyToBeTransferred) public {
		// not making any checks
		addressToAddress(residentIdToAddress[fromResidentId], residentIdToAddress[toResidentId], energyToBeTransferred);	
	}

	function doubleAuction() public {
		// double auction method will be called by the owner of the Exchange contract after the bidding period
		require(owner==msg.sender);

		// Here you need to insert the logic for arriving at the clearingPrice based on the values in the bidsToSell and 
		// bidsToBuy maps



		// hardcoding all value transfers according to hardcoded clearing price
		uint clearingPrice = 98;
		addressToAddress(generatorIdToAddress["G3"], buyerIdToAddress["B1"], 400);
		addressToAddress(generatorIdToAddress["G3"], buyerIdToAddress["B2"], 200);
		addressToAddress(generatorIdToAddress["G3"], buyerIdToAddress["B3"], 200);
		addressToAddress(generatorIdToAddress["G1"], buyerIdToAddress["B3"], 100);

		// Now need to do the cash transfer to the generators (ether transfer for simplicity)
		generatorIdToAddress["G3"].transfer(800*clearingPrice);
		generatorIdToAddress["G1"].transfer(100*clearingPrice);
		
		// need to refund excess ether submitted by buyers
		// first number is bidPrice-clearingPrice, second is amount of tokens
		buyerIdToAddress["B1"].transfer(2*400);
		buyerIdToAddress["B1"].transfer(0*200);
		buyerIdToAddress["B1"].transfer(4*300);

	}

}