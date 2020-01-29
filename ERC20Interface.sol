pragma solidity >=0.5.0 < 0.6.0;

interface ERC20Interface {

    function totalSupply() external view returns (uint);

    function balanceOf(address _owner) external view returns (uint balance);

    function allowance(address _owner, address _spender) external view returns (uint remaining);

    function transfer(address _to, uint _tokens) external returns (bool success);

    function approve(address _spender, uint _tokens) external returns (bool success);

    function transferFrom(address _from, address _to, uint _tokens) external returns (bool success);


    event Transfer(address indexed _from, address indexed _to, uint _tokens);

    event Approval(address indexed _owner, address indexed _spender, uint _tokens);

}
