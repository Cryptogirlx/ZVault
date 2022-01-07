pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IAaveStrategy.sol";

contract ZVault is ERC20, Ownable {
    // address[] strategyContracts;
    address AaveStrategy;
    address CompStrategy;

    ERC20 public DAI;

    // needs mint function to mint zDAI

    //mappings
    mapping(address => uint256) public DAIBalanceInVault;
    mapping(address => uint256) public zDAIBalanceInVault;
    // mapping(address => bool) public isRegisteredStrategy;
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

    // modifiers

    modifier notShutdown(address sContract) {
        require(!isShutdown[sContract], "CONTRACT IS SHUTDOWN");
        _;
    }

    constructor(
        address _AaveStrategy,
        address _AaveStrategy,
        address _DAI
    ) ERC20("zDAI", "zDAI") {
        _AaveStrategy = AaveStrategy;
        _AaveStrategy = CompStrategy;
        DAI = ERC20(_DAI); // where do we get the DAI address from?
        DAI.approve(AaveStrategy, type(uint256).max);
        DAI.approve(CompStrategy, type(uint256).max);
    }

    // * VIEW FUNCTIONS * //

    // function isStrategy(address sContract) public view returns (bool) {
    //     return isRegisteredStrategy[sContract];
    // }

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
    // function setNewStrategy(address newContract)
    //     external
    //     onlyOwner
    //     notShutdown
    // {
    //     strategyContract = newContract; // needs to be replaced with array
    //     isRegisteredStrategy[newContract] = true;

    //     emit StrategyRegistered(newContract);
    // }

    // * VAULT LOGIC * //

    function deposit(uint256 amount) public notShutdown returns (uint256) {
        require(
            DAI.balanceOf(msg.sender) >= amount,
            "NOT ENOUGH BALANCE TO DEPOSIT"
        );
        require(0 > amount, "CANNOT DEPOSIT 0");
        DAI.transferFrom(msg.sender, address(this), amount);
        emit Deposit(amount);

        // mints 1:1 zDAI to users account
        _mint(msg.sender, amount);
    }

    function withdraw(
        address to,
        uint256 amount,
        address sContract
    ) public notShutdown {
        uint256 _daiInVault = getDaiBalanceInVault(msg.sender);

        uint256 _zDaiBalanceBefore = balanceOf(msg.sender);
        // to withdraw you have to burn zDAIn
        _burn(msg.sender, amount);

        uint256 _zDaiBalanceAfter = balanceOf(msg.sender);
        // check if tokens are burned

        require(
            _zDaiBalanceAfter = _zDaiBalanceBefore - amount,
            "YOU HAVE TO BURN ZDAI TO WITHDRAW"
        );

        if (sContract == AaveStrategy) {
            uint256 _daiInAave = IAaveStrategy.getTotalBalance(msg.sender);
            require(
                _daiInAave + _daiInVault >= amount,
                "INSUFFICENT FUNDS TO WITHDRAW"
            );
            require(to != address(0), "WITHDRAW TO ZERO ADDRESS");

            _removeDaiFromAave(amount);
            emit DaiRemovedFromStrategy(amount, sContract);
        }
        // if (sContract == CompStrategy) {
        //     uint256 _daiInComp = ICompStrategy.getTotalBalance(msg.sender);
        //     require(
        //         _daiInComp + _daiInVault >= amount,
        //         "INSUFFICENT FUNDS TO WITHDRAW"
        //     );
        //     require(to != address(0), "WITHDRAW TO ZERO ADDRESS");
        // }

        emit Withdraw(to, amount);
    }

    function moveDaiToStrategy(uint256 amount, address sContract)
        public
        notShutdown
        onlyOwner
    {
        uint256 _daiInVault = getDaiBalanceInVault(msg.sender);
        require(_daiInVault >= amount, "INSUFFICIENT FUNDS TO MOVE");
        if (sContract == AaveStrategy) {
            _moveDaiToAaveStrategy(amount);
        }
        if (sContract == Compstrategy) {
            _moveDaiToCompStrategy(amount);
        }
        emit DaiMovedToStrategy(amount, sContract);
    }

    function _moveDaiToAaveStrategy(uint256 _amount) internal {
        require(_amount > 0, "NO ZERO DEPOSITS");
        DAI.transferFrom(address(this), AaveStrategy, _amount);
    }

    function _moveDaiToCompStrategy(uint256 _amount) internal {
        require(_amount > 0, "NO ZERO DEPOSITS");
        DAI.transferFrom(address(this), CompStrategy, _amount);
    }

    function _removeDaiFromAave(uint256 _amount) internal {
        // cannot remove more than balance in AAve
    }

    function _removeDaiFromComp(uint256 _amount) internal {}

    function checkBalanceInStrategy(address user, address sContract) public {
        if (sContract == AaveStrategy) {
            IAaveStrategy.getTotalBalance(user);
        }
        if (sContract == Compstrategy) {
            ICompStrategy.getTotalBalance(user);
        }
    }

    function checkProfits(address user, address sContract)
        public
        returns (uint256)
    {
        // check zDAI profits from both Aave and Comp
        if (sContract == AaveStrategy) {
            uint256 totalBal = IAaveStrategy.getTotalBalanceInAave(user);
            uint256 totalDeposited = IAaveStrategy.getTotalBalanceInStrategy(
                user
            ); // how do I get the deposited amount;
            uint256 daiProfits = totalBal - deposited;

            return daiProfits;
        }
        if (sContract == Compstrategy) {
            _checkProfitsInComp(user);
        }
    }

    function _checkProfitsInAave(address user) internal {}

    function _checkProfitsInComp(address user) internal {}

    function claimRewardsFromStrategy(address sContract) public onlyOwner {
        if (sContract == AaveStrategy) {
            _claimRewardsFromAave();
        }
        if (sContract == Compstrategy) {
            _claimRewardsFromComp();
        }
    }

    function _claimRewardsFromAave() internal {}

    function _claimRewardsFromComp() internal {}

    function shutdown(address sContract, bool _isShutdown)
        external
        override
        onlyOwner
    {
        isShutdown[sContract] = _isShutdown;
    }
}
