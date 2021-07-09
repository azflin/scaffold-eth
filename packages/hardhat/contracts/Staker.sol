pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Staker {

  ExampleExternalContract public exampleExternalContract;
  mapping(address => uint) public balances;
  uint public constant threshold = 0.001 ether;
  uint public deadline = now + 30 seconds;
  event Stake(address _staker, uint256 _stakedAmount);

  constructor(address exampleExternalContractAddress) public {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  modifier notCompleted() {
    require(!exampleExternalContract.completed(), "exampleExternalContract must be not completed.");
    _;
  }

  modifier deadlinePassed() {
    require(now > deadline, "Deadline has not passed yet.");
    _;
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() external payable {
    require(now < deadline, "Can only stake before deadline.");
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  function execute() external notCompleted deadlinePassed {
    require(address(this).balance >= threshold, "Contract's balance is not greater than or equal to threshold.");
    exampleExternalContract.complete{value: address(this).balance}();
  }

  // if the `threshold` was not met, allow everyone to call a `withdraw()` function
  function withdraw(address payable _to) external notCompleted deadlinePassed {
    uint256 amount = balances[_to];
    balances[_to] = 0;
    (bool success,) = msg.sender.call{value: amount}("");
    require(success, "Failed to send ether");
  }


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns(uint256) {
    if (now >= deadline) {
      return 0;
    } else {
      return deadline - now;
    }
  }

}
