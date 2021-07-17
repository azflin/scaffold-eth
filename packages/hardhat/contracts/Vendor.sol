pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  YourToken yourToken;
  uint256 public constant tokensPerEth = 1000;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfEth, uint256 amountOfTokens);

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() external payable {
    require(msg.value > 0, "You need to send some ether.");
    uint256 amountToBuy = msg.value * tokensPerEth;
    require(amountToBuy <= yourToken.balanceOf(address(this)), "Vendor doesn't have enough tokens to sell.");
    yourToken.transfer(msg.sender, amountToBuy);
    emit BuyTokens(msg.sender, msg.value, msg.value * tokensPerEth);
  }

  function sellTokens(uint256 _tokensToSell) external {
    require(_tokensToSell > 0, "You need to sell at least some tokens");
    yourToken.transferFrom(msg.sender, address(this), _tokensToSell);
    uint amountEth = _tokensToSell / tokensPerEth;
    (bool success,) = msg.sender.call{value: amountEth}("");
    require(success, "Failed to send ether.");
    emit SellTokens(msg.sender, amountEth, _tokensToSell);
  }

  function withdraw() external onlyOwner {
    yourToken.transfer(msg.sender, yourToken.balanceOf(address(this)));
  }
}
