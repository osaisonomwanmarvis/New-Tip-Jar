// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TippingJar {
    address public owner;

    struct Tip {
        uint256 totalAmount;
        uint256 tipCount;
    }

    mapping(address => Tip) public tips;
    address[] public tippers;

    constructor() {
        owner = msg.sender;
    }

    // Accept tips
    receive() external payable {
        require(msg.value > 0, "Tip must be more than 0");

        if (tips[msg.sender].tipCount == 0) {
            tippers.push(msg.sender);
        }

        tips[msg.sender].totalAmount += msg.value;
        tips[msg.sender].tipCount += 1;
    }

    // Get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Return top N tippers (sorted by amount)
    function getTopTippers(uint256 topN) external view returns (address[] memory, uint256[] memory) {
        uint256 count = tippers.length < topN ? tippers.length : topN;
        address[] memory sortedAddresses = new address[](tippers.length);
        uint256[] memory sortedAmounts = new uint256[](tippers.length);

        // Copy data to arrays for sorting
        for (uint256 i = 0; i < tippers.length; i++) {
            sortedAddresses[i] = tippers[i];
            sortedAmounts[i] = tips[tippers[i]].totalAmount;
        }

        // Simple bubble sort (not gas efficient, good for small N)
        for (uint256 i = 0; i < sortedAmounts.length; i++) {
            for (uint256 j = i + 1; j < sortedAmounts.length; j++) {
                if (sortedAmounts[j] > sortedAmounts[i]) {
                    // Swap amounts
                    (sortedAmounts[i], sortedAmounts[j]) = (sortedAmounts[j], sortedAmounts[i]);
                    // Swap addresses
                    (sortedAddresses[i], sortedAddresses[j]) = (sortedAddresses[j], sortedAddresses[i]);
                }
            }
        }

        // Trim arrays
        address[] memory topAddresses = new address[](count);
        uint256[] memory topAmounts = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            topAddresses[i] = sortedAddresses[i];
            topAmounts[i] = sortedAmounts[i];
        }

        return (topAddresses, topAmounts);
    }

    // Withdraw (only owner)
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
