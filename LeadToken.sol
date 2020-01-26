pragma solidity >=0.5.0 < 0.6.0;

import "./Owned.sol"

contract LeadToken is Owned {

    // Public variables of the LeadToken
    string public name = "LeadToken";
    string public symbol = "LEAD";
    string public standard = "Lead Token v1.0";
    uint8 public decimals = 18; 
    uint public totalSupply;
    
    // Generates a public event on the blockchain that will notify clients
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint _value
    );
    
    // This notifies clients about the amount burnt
    event Burn(
        address indexed from, 
        uint256 value
    );
    
    // Generates a public event on the blockchain that will notify clients
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    
    // This creates an array with all balances
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowed;
    
    /**
     * Constructor function 
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    constructor(uint _initialSupply) public {
        balanceOf[msg.sender] = totalSupply;
        totalSupply = _initialSupply * 10 ** uint(decimals);
        emit Transfer(address(0x0), msg.sender, totalSupply);
    }
    
    /**
     * Internal transfer, can only be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != address(0x0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }
    
    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint _value) public returns(bool success){
        _transfer(msg.sender, _to, _value);
        return true;
    }
    
    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` in behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(_value <= allowed[_from][msg.sender]);
        allowed[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    
    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens in your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    /**
     * Returns the amount of tokens approved by the owner that can be transferred to the spender's account
     */
    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return allowed[_owner][_spender];
    }
    
    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value is the amount of token to burn
     */
    function burn(uint _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   
        balanceOf[msg.sender] -= _value;          
        totalSupply -= _value;                      
        emit Burn(msg.sender, _value);
        return true;
    }
    
    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);                
        require(_value <= allowed[_from][msg.sender]); 
        balanceOf[_from] -= _value;                        
        allowed[_from][msg.sender] -= _value;             
        totalSupply -= _value;                             
        emit Burn(_from, _value);
        return true;
    }
    
}
