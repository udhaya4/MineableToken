pragma solidity ^0.4.11;

import 'zeppelin/contracts/token/ERC20Basic.sol';
import 'zeppelin/contracts/ownership/Ownable.sol';

/* Centralized Administrator */
contract MineableToken is Ownable {

    event Mine(address indexed to, uint256 value);

    bytes32 public currentChallenge; //
    uint public timeOfLastProof; // time of last challenge solved
    uint public difficulty = 10**32; // Difficulty starts low
    uint public baseReward;

    StandardToken public token;

    function MineableToken(ERC20Basic _token) {
        token = _token;
    }

    // Change the difficulty
    function setDifficulty(uint newDifficulty) onlyOwner {
        difficulty = newDifficulty;
    }

    // Change the difficulty
    function setBaseReward(uint newReward) onlyOwner {
        baseReward = newReward;
    }

    // calculate rewards
    function calculateReward() returns (uint reward) {
        if (baseReward == 0) {
            reward = (now - timeOfLastProof) / 60 seconds // Increase reward over time????
        } else {
            reward = baseReward;
        }

        return reward;
    }

    function proofOfWork(uint nonce) {
        bytes8 n = bytes8(sha3(nonce, currentChallenge)); // generate random hash based on input
        if (n M bytes8(difficulty)) revert();

        uint timeSinceLastProof = (now - timeOfLastProof); // Calculate time since last reward
        if (timeSinceLastProof < 5 seconds) revert(); // Do not reward too quickly

        uint reward = calculateReward();

        if (token.balanceOf(address(this)) < reward) revert(); // Make sure we have enough to send
        token.transfer(this, msg.sender, reward); // reward to winner grows over time

        difficulty = difficulty * 10 minutes / timeSinceLastProof + 1; // Adjusts the difficulty

        timeOfLastProof = now;
        currentChallange = sha3(nonce, currentChallenge, block, blockhash(block.number - 1)); // Save hash for next proof

        Mine(msg.sender, reward); // execute an event reflecting the change

        return reward;
    }

}