pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  YourToken yourToken;
  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  //ToDo: create a payable buyTokens() function:
  function buyTokens() external payable {
    require(msg.value > 0, "You need to send some ether.");
    uint256 amountToBuy = msg.value * tokensPerEth;
    require(amountToBuy <= yourToken.balanceOf(address(this)), "Vendor doesn't have enough tokens to sell.");
    yourToken.transfer(msg.sender, amountToBuy);
    emit BuyTokens(msg.sender, msg.value, msg.value * tokensPerEth);
  }

  //ToDo: create a sellTokens() function:
  // function sellTokens(uint256 _tokensToSell) external {
  //   yourToken.transfer(address(this), _tokensToSell);
  //   (bool success,) = msg.sender.call{value: _tokensToSell / tokensPerEth}("");
  //   require(success, "Failed to send ether.");
  // }

  //ToDo: create a withdraw() function that lets the owner, you can 
  //use the Ownable.sol import above:
  function withdraw() external onlyOwner {
    yourToken.transfer(msg.sender, yourToken.balanceOf(address(this)));
  }
}
