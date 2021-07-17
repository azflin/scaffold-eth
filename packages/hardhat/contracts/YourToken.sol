pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YourToken is ERC20 {
    constructor() public ERC20("Finney", "FIN") {
        _mint(msg.sender, 88888888 * 10 ** 18);
    }
}
