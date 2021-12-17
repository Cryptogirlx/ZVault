pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ZVault {
    address strategyContract;

    IERC20 public DAI;

    //mappings
    mapping(address => uint256) public DAIBalance;
    mapping(address => uint256) public yTokenBalance;
    mapping(address => bool) public isRegisteredStrategy;
    mapping(address => bool) public isRegisteredStrategy;
    mapping(address => bool) public isShutDown;

    // events
    event Transfer(address from, address to, uint256 amount);
    event Deposit(uint256 amount);
    event Withdraw(address to, uint256 amount);
    event StrategyRegistered(address sContract);
    event StrategyRemoved(address sContract);
    event ShutDown(bool active);

    // modifiers

    modifier notShutdown() {
        require(!isShutdown, "CONTRACT IS SHUTDOWN");
        _;
    }

    constructor() {}

    function isStrategy(address sContract) public view returns (bool) {
        return isRegisteredStrategy[sContract];
    }

    function checkDaiBalance(address user) public view returns (uint256) {
        return DAIBalance[user];
    }

    function checkyTokenBalance(address user) public view returns (uint256) {
        return yTokenBalance[user];
    }

    function setNewStrategy(address newContract)
        external
        onlyOwner
        notShutdown
    {
        strategyContract = newContract;

        emit StrategyRegistered(newContract);
    }

    function deposit(uint256 amount) external notShutdown {
        require(DAI.transferFrom(address(this), _amount), "DEPOSIT FAILED");
        emit Deposit(amount);
    }

    function withdraw(address to, uint256 amount) external notShutdown {
        require(to != address(0), "WITHDRAW TO ZERO ADDRESS");
        emit Withdraw(to, amount);
    }
}
