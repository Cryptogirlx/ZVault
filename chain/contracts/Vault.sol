pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ZVault is IERC20 {
    address strategyContract;

    IERC20 public DAI;

    //mappings
    mapping(address => uint256) public DAIBalanceInVault;
    mapping(address => uint256) public yTokenBalanceInVault;
    mapping(address => bool) public isRegisteredStrategy;
    mapping(address => bool) public isShutDown;

    // events
    event Transfer(address from, address to, uint256 amount);
    event Deposit(uint256 amount);
    event Withdraw(address to, uint256 amount);
    event StrategyRegistered(address sContract);
    event StrategyRemoved(address sContract);
    event ShutDown(bool active);
    event DaiMovedFromAaveToVault(uint256 amount);
    event DaiMovedFromTreasuryToVault(uint256 amount);

    // modifiers

    modifier notShutdown() {
        require(!isShutdown, "CONTRACT IS SHUTDOWN");
        _;
    }

    constructor() {}

    // * VIEW FUNCTIONS * //

    function isStrategy(address sContract) public view returns (bool) {
        return isRegisteredStrategy[sContract];
    }

    function getDaiBalanceInVault(address user) public view returns (uint256) {
        return DAIBalanceInVault[user];
    }

    function getyTokenBalanceInVault(address user)
        public
        view
        returns (uint256)
    {
        return yTokenBalanceInVault[user];
    }

    function setNewStrategy(address newContract)
        external
        onlyOwner
        notShutdown
    {
        strategyContract = newContract;

        emit StrategyRegistered(newContract);
    }

    function checkBalanceInAave(address user) public notShutdown {
        // call balance of function from strategy contract
    }

    function checkBalanceInCompound(address user) public notShutdown {
        // call balance of function from strategy contract
    }

    // * VAULT LOGIC * //

    function deposit(uint256 amount) public notShutdown {
        require(DAI.transferFrom(address(this), _amount), "DEPOSIT FAILED");
        emit Deposit(amount);
    }

    function withdraw(address to, uint256 amount) public notShutdown {
        require(to != address(0), "WITHDRAW TO ZERO ADDRESS");
        emit Withdraw(to, amount);
    }

    function moveDaiToAave(uint256 amount) public notShutdown {
        uint256 _daiInVault = getDaiBalanceInVault();
        require(_daiInVault >= _amount, "INSUFFICIENT FUNDS TO MOVE");
        _moveDaiToAave(amount);
    }

    function moveDaiFromAave(uint256 amount) public notShutdown {}

    function moveDaiToComp(uint256 amount) public notShutdown {
        uint256 _daiInVault = getDaiBalanceInVault();
        require(_daiInVault >= _amount, "INSUFFICIENT FUNDS TO MOVE");
        _moveDaiToComp(amount);
    }

    function moveDaiFromComp(uint256 amount) public notShutdown {}

    function _moveDaiToAave(uint256 _amount) internal {
        require(_amount > 0, "NO ZERO DEPOSITS");
    }

    function _moveDaiToComp(uint256 _amount) internal {
        require(_amount > 0, "NO ZERO DEPOSITS");
    }
}
