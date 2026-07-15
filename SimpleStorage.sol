// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SimpleStorage
 * @dev A simple smart contract to store, retrieve, increment, and decrement a single uint256 value.
 * Access to state-modifying functions is restricted to the contract owner.
 */
contract SimpleStorage {
    // ==========================================
    // STATE VARIABLES
    // ==========================================

    // The single uint256 value being stored
    uint256 private storedValue;

    // The owner of the contract (immutable for gas efficiency since it won't change after deployment)
    address public immutable owner;

    // ==========================================
    // EVENTS
    // ==========================================

    // Emitted whenever the stored value changes
    event ValueChanged(uint256 indexed newValue, address indexed updatedBy);

    // ==========================================
    // MODIFIERS
    // ==========================================

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "SimpleStorage: caller is not the owner");
        _;
    }

    // ==========================================
    // CONSTRUCTOR
    // ==========================================

    /**
     * @dev Sets the contract owner and initializes the stored value.
     * @param initialValue The initial uint256 value to store.
     */
    constructor(uint256 initialValue) {
        owner = msg.sender;
        storedValue = initialValue;
        emit ValueChanged(initialValue, msg.sender);
    }

    // ==========================================
    // MUTATIVE FUNCTIONS (Owner Only)
    // ==========================================

    /**
     * @dev Sets a new value. Restricted to owner.
     * @param newValue The new uint256 value to set.
     */
    function setValue(uint256 newValue) external onlyOwner {
        storedValue = newValue;
        emit ValueChanged(newValue, msg.sender);
    }

    /**
     * @dev Increments the stored value by 1. Restricted to owner.
     */
    function incrementValue() external onlyOwner {
        // Prevent overflow using require (even though Solidity 0.8+ reverts automatically, 
        // explicit input/state validation is clean and friendly for beginners)
        require(storedValue < type(uint256).max, "SimpleStorage: value overflow");
        
        storedValue += 1;
        emit ValueChanged(storedValue, msg.sender);
    }

    /**
     * @dev Decrements the stored value by 1. Restricted to owner.
     */
    function decrementValue() external onlyOwner {
        // Prevent underflow using require
        require(storedValue > 0, "SimpleStorage: value underflow");
        
        storedValue -= 1;
        emit ValueChanged(storedValue, msg.sender);
    }

    // ==========================================
    // VIEW FUNCTIONS (Public)
    // ==========================================

    /**
     * @dev Retrieves the stored value.
     * @return The current stored uint256 value.
     */
    function getValue() external view returns (uint256) {
        return storedValue;
    }
}
