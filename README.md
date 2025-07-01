# New-Tip-Jar
#  TippingJar Smart Contract

A simple Solidity-based Ethereum smart contract that allows users to send tips (in Ether) to a deployed contract and tracks top tippers by total contributions.

---

## Features

- Accepts tips from any address
- Tracks:
  - Total amount tipped per address
  - Number of times each address tipped
- Stores a list of all unique tippers
- Returns a ranked list of top tippers
- Contract owner can withdraw all accumulated funds

---

## Smart Contract Structure

```solidity
struct Tip {
    uint256 totalAmount;
    uint256 tipCount;
}

mapping(address => Tip) public tips;
address[] public tippers;
