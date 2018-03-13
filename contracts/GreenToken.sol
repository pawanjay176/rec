pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract GreenToken is StandardToken {
    string public constant name = "GreenToken";
    string public constant symbol = "GTK";
    
    uint8 public constant decimals = 18; // solium-disable-line uppercase

    uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  function GreenToken() public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    Transfer(0x0, msg.sender, INITIAL_SUPPLY);

    // transfer 400 tokens to the first generator. You can hardcode these values for specific addresses that you want
    transfer(0xbaa7b4b89827a1b3040749864f8d20f119822e87, 400);

  }

}
