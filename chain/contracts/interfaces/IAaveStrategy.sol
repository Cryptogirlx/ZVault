pragma solidity 0.8.7;

interface IAaveStrategy {
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
