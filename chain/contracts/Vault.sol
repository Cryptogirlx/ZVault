pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ZVault is ERC20, Ownable {
    address[] strategyContracts;
    address AaveStrategy = "x";
    address Compstrategy = "y";

    ERC20 public DAI;
    ERC20 public zDAI;

    //mappings
    mapping(address => uint256) public DAIBalanceInVault;
    mapping(address => uint256) public zDAIBalanceInVault;
    mapping(address => bool) public isRegisteredStrategy;
    mapping(address => bool) public isShutDown;
    mapping(uint256 => address) public startegyAddress;

    // events
    event Transfer(address from, address to, uint256 amount);
    event Deposit(uint256 amount);
    event Withdraw(address to, uint256 amount);
    event StrategyRegistered(address sContract);
    event StrategyRemoved(address sContract);
    event ShutDown(bool active);
    event DaiMovedToStrategy(uint256 amount, address sConract);
    event DaiRemovedFromStrategy(uint256 amount, address sConract);

    // event FundsSwapped(uint256 amount, address strategyContract);

    // modifiers

    modifier notShutdown(address sContract) {
        require(!isShutdown[sContract], "CONTRACT IS SHUTDOWN");
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

    // * SETTERS * //
    function setNewStrategy(address newContract, bool registered)
        external
        onlyOwner
        notShutdown
    {
        strategyContract = newContract;
        registered[newContract] = true;

        emit StrategyRegistered(newContract);
    }

    function checkBalanceInStrategy(address user, address sContract) public {
        if (sContract == AaveStrategy) {
            _checkBalanceInAave(user);
        }
        if (sContract == Compstrategy) {
            _checkBalanceInComp(user);
        }
    }

    function _checkBalanceInAave(address user) internal {
        // call balance of function from strategy contract
    }

    function _checkBalanceInComp(address user) internal {
        // call balance of function from strategy contract
    }

    function checkProfits(address user, address sContract) public {
        // check zDAI profits from both Aave and Comp
        if (sContract == AaveStrategy) {
            _checkProfitsInAave(user);
        }
        if (sContract == Compstrategy) {
            _checkProfitsInComp(user);
        }
    }

    function _checkProfitsInAave(address user) internal {}

    function _checkProfitsInComp(address user) internal {}

    // * VAULT LOGIC * //

    function deposit(uint256 amount) public notShutdown {
        require(DAI.transferFrom(msg.sender, _amount), "DEPOSIT FAILED");
        emit Deposit(amount);
        // when deposit they need to get yDAI back, gets minted into account
    }

    function withdraw(address to, uint256 amount) public notShutdown {
        require(to != address(0), "WITHDRAW TO ZERO ADDRESS");
        emit Withdraw(to, amount);
    }

    function moveDaiToStrategy(uint256 amount, address sContract)
        public
        notShutdown
        onlyOwner
    {
        uint256 _daiInVault = getDaiBalanceInVault();
        require(_daiInVault >= amount, "INSUFFICIENT FUNDS TO MOVE");
        if (sContract == AaveStrategy) {
            _moveDaiToAave(amount);
        }
        if (sContract == Compstrategy) {
            _moveDaiToComp(amount);
        }
        emit DaiMovedToStrategy(amount, sContract);
    }

    function _moveDaiToAave(uint256 _amount) internal {
        require(_amount > 0, "NO ZERO DEPOSITS");
    }

    function _moveDaiToComp(uint256 _amount) internal {
        require(_amount > 0, "NO ZERO DEPOSITS");
    }

    function removeDaiFromStrategy(uint256 amount, address sContract)
        public
        notShutdown
    {
        if (sContract == AaveStrategy) {
            _moveDaiToAave(amount);
        }
        if (sContract == Compstrategy) {
            _moveDaiToComp(amount);
        }

        emit DaiRemovedFromStrategy(amount, sContract);
    }

    function _removeDaiFromAave(uint256 _amount) internal {}

    function _removeDaiFromComp(uint256 _amount) internal {}

    // function _swapFunds(uint256 amount, address strategyContract) internal {
    //     require(_amount > 0, "FUNDS MOVED ARE 0 OR NEGATIVE");
    //     emit FundsSwapped(amount, strategyContract);
    // }
}
