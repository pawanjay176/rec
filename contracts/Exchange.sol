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

	address GreenTokenAddress = 0xd37e91f5a282036a28f5e78963edddf26462a23a;

	mapping (string => address) generatorIdToAddress;
	mapping (string => address) buyerIdToAddress;
	mapping (string => address) utilityIdToAddress;
	mapping (string => address) residentIdToAddress;

	Generator [] generators;
	Buyer [] public buyers;
	Utility [] public utilities;
	Resident [] public residents;

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



	function addressToAddress (address from, address to, uint amount) private {
		StandardToken greenToken = StandardToken(GreenTokenAddress);
		greenToken.transferFrom(from, to, amount);
	}
	

	function generatorToUtility(string generatorId, string utilId, uint amount) public {
		// Not making any checks
		addressToAddress(generatorIdToAddress[generatorId], utilityIdToAddress[utilId], amount);
	}

	function residentToResident(string fromResidentId, string toResidentId, uint energyToBeTransferred) public {
		addressToAddress(residentIdToAddress[fromResidentId], residentIdToAddress[toResidentId], energyToBeTransferred);	
	}

	function doubleAuction() {
		uint clearingPrice = 99;
		addressToAddress(generatorIdToAddress["G3"], buyerIdToAddress["B1"], 400);
		addressToAddress(generatorIdToAddress["G3"], buyerIdToAddress["B2"], 200);
		addressToAddress(generatorIdToAddress["G3"], buyerIdToAddress["B3"], 200);
		addressToAddress(generatorIdToAddress["G1"], buyerIdToAddress["B3"], 100);
	}

}