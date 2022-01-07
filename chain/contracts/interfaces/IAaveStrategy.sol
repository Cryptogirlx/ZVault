pragma solidity 0.8.7;

interface IAaveStrategy {
    function getTotalBalanceInStrategy(address user)
        external
        view
        returns (uint256);

    function getTotalBalanceInAave(address user)
        external
        view
        returns (uint256);

    function moveFunds(uint256 amount) external;

    function removeFunds(uint256 amount) external;

    function checkProfits(address user) external view returns (uint256);
}
