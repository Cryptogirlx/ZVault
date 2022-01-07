pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AaveStrategy is IAaveStrategy, ERC20, Ownable {
    address public override aaveLendingPoolAddress;

    mapping(address => uint256) daiDeposited;

    IERC20 public DAI;

    constructor(
        address _DAI,
        address _aDAI,
        address _aaveIncentivesController,
        address _lendingPool
    ) {
        daiAddress = _DAI;
        aaveLendingPoolAddress = _lendingPool;
        DAI = IERC20(_DAI);
        aDAI = IAToken(_aDAI);
        AaveIncentivesController = IAaveIncentivesController(
            _aaveIncentivesController
        );
        AaveLendingPool = ILendingPool(_lendingPool);

        // Infinite approve Aave for DAI deposits
        DAI.approve(_lendingPool, type(uint256).max);
    }

    // modifiers

    function setLendingPool(address _AaveLendingPool) external onlyOwner {}

    function getTotalBalanceInStrategy(address user)
        external
        view
        returns (uint256)
    {
        return daiDeposited[user];
    }

    function getTotalBalanceInAave(address user)
        external
        view
        returns (uint256)
    {
        // get total balance including profits from Aave
    }

    function moveFunds(uint256 amount) external notShutdown {
        // deposit funds to Aave Lending Pool
    }

    function removeFunds(uint256 amount) external {
        // remove dai from Aave
    }

    function claimAaveRewards(uint256 _amountToClaim)
        external
        override
        onlyOwner
    {
        // claiming Aave rewards
    }
}
