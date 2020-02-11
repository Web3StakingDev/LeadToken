pragma solidity >=0.5.0 < 0.6.0;

import "./LeadToken.sol";
import "./Owned.sol";

contract LeadStake is LeadToken, Owned {
    
    /**
     * @notice We usually require to know who are all the stakeholders.
     */
    address[] internal stakeholders;
    
    /**
     * @notice The stakes for each stakeholder.
     */
    mapping(address => uint) internal stakes;
    
    /**
     * @notice The accumulated rewards for each stakeholder.
     */
    mapping(address => uint) internal rewards;

    /**
     * @notice The constructor for the Staking Token.
     * @param _owner The address to receive all tokens on construction.
     * @param _supply The amount of tokens to mint on construction.
     */
    constructor(address _owner, uint _supply) public {
        _mint(_owner, _supply);
    }
    
     /**
     * @notice A method to check if an address is a stakeholder.
     * @param _address The address to verify.
     * @return bool, uint Whether the address is a stakeholder,
     * and if so its position in the stakeholders array.
     */

    function isStakeholder(address _address) public view returns(bool, uint256) {
        for (uint i = 0; i < stakeholders.length; i++){
            if (_address == stakeholders[i]) return (true, i);
        }
        return (false, 0);
    }

    /**
     * @notice A method to add a stakeholder.
     * @param _stakeholder is the stakeholder to add.
     */
     
    function addStakeholder(address _stakeholder) public {
        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
        if(!_isStakeholder) stakeholders.push(_stakeholder);
    }

    /**
     * @notice A method to remove a stakeholder.
     * @param _stakeholder is the stakeholder to remove.
     */
    function removeStakeholder(address _stakeholder) public {
        (bool _isStakeholder, uint i) = isStakeholder(_stakeholder);
        if(_isStakeholder) {
           stakeholders[i] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        }
    }
    
    /**
     * @notice A method to retrieve the stake for a stakeholder.
     * @param _stakeholder The stakeholder to retrieve the stak for.
     * @return uint The amount of wei staked.
     */
    function stakeOf(address _stakeholder) public view returns(uint) {
        return stakes[_stakeholder];
    }

    /**
     * @notice A method to the aggregated stakes from all stakeholders.
     * @return uint The aggregated stakes from all stakeholders.
     */
    function totalStakes() public view returns(uint) {
        uint _totalStakes = 0;
        for (uint i = 0; i < stakeholders.length; i++) {
            _totalStakes += stakes[stakeholders[i]];
        }
        return _totalStakes;
    }
    
     /**
     * @notice A method for a stakeholder to create a stake.
     * @param _stake The size of the stake to be created.
     */
    function createStake(uint _stake) public {
        burnFrom(msg.sender, _stake);
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        stakes[msg.sender] += _stake;
    }

    /**
     * @notice A method for a stakeholder to remove a stake.
     * @param _stake The size of the stake to be removed.
     */
    function removeStake(uint _stake) public {
        stakes[msg.sender] -= _stake;
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }

    /**
     * @notice A method to allow a stakeholder to check his rewards.
     * @param _stakeholder is the stakeholder to check rewards for.
     */
    function rewardOf(address _stakeholder) public view returns(uint) {
        return rewards[_stakeholder];
    }

    /**
     * @notice A method to the aggregated rewards from all stakeholders.
     * @return uint The aggregated rewards from all stakeholders.
     */
    function totalRewards() public view returns(uint) {
        uint _totalRewards = 0;
        for (uint i = 0; i < stakeholders.length; i++){
            _totalRewards += rewards[stakeholders[i]];
        }
        return _totalRewards;
    }
    
    /**
     * @notice A simple method that calculates the rewards for each stakeholder.
     * @param _stakeholder is the stakeholder to calculate rewards for.
     */
    function calculateReward(address _stakeholder) public view returns(uint) {
        return stakes[_stakeholder] / 100;
    }

    /**
     * @notice A method to distribute rewards to all stakeholders.
     */
    function distributeRewards() public onlyOwner {
        for (uint i = 0; i < stakeholders.length; i++){
            address stakeholder = stakeholders[i];
            uint reward = calculateReward(stakeholder);
            rewards[stakeholder] += reward;
        }
    }

    /**
     * @notice A method to allow a stakeholder to withdraw his rewards.
     */
    function withdrawReward() public {
        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);
    }
}
