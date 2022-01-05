pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AaveStrategy is IAaveStrategy, ERC20, Ownable {
    mapping(address => uint256) public daiInStrategy;

    constructor() {}

    // modifiers

    modifier notShutdown(address sContract) {
        require(!isShutdown[sContract], "CONTRACT IS SHUTDOWN");
        _;
    }

    function getTotalBalance(address user) external view returns (uint256) {
        // get total balance including profits from Aave
    }

    function moveFunds(uint256 amount) external notShutdown {
        // deposit funds to Aave Lending Pool
    }

    function removeFunds(uint256 amount) external {
        // remove dai from Aave
    }
}
