// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract BankAccount{

    event Deposit(address  indexed user, uint indexed accountId, uint value,uint timestamp);
    event WithdrawRequest(address indexed user, uint256 accountId, uint256 withdrawId, uint256 amount, uint256 timestamp);
    event Withdraw(uint indexed withdrawId, uint timestamp);
    event AccountCreated(address[] owners, uint indexed id, uint timestamp);
    
    struct withDrawRequest {
        address user;
        uint amount;
        uint approvals;
        mapping(address => bool) ownerApproved;
        bool approved;
    }
    struct Account{
        address[] owners;
        uint balance;
        mapping(uint => withDrawRequest) withDrawRequests;
    }

    mapping(uint=> Account) accounts;
    mapping(address => uint[]) userAccounts;
    uint nextAccountId;
    uint nextWithdrawId;

    modifier accountOwner(uint accountId){
        bool isOwner;
        for(uint idx; idx < accounts[accountId].owner.length;idx++){
            if(accounts[accountId].owner[idx] == msg.sender){
                isOwner = true;
                break
            }
        }
        require(isOwner, "You are not the owner of the account");
        _;
    }
    modifier validOwners(address[] calldata owners){
        require(owners.length + 1 == 4, "Maximum 4 account per owner");
        for(uint idx;idx < owners.length;idx++){
            for(uint jdx = idx + 1; jdx < owners.length; jdx++){
                if(owners[idx] == owners[jdx]){
                    revert("No duplicate owners");
                }
            }
        }
        _;
    }
    modifier sufficientBalance(uint accountId,uint amount){
        uint balance = accounts[accountId].balance;
        require(amount <= balance, "Not Sufficent Balance In Account");
        _;
    }
    //start writing the code 
    modifier validApproval(uint accountId, uint withdrawId){
        
        _;
    }
    function deposit(uint accountId) external payable accountOwner(accountId){
        accounts[accountId].balance += msg.value
    }
    function createAccount(address[] calldata otherOwners)  validOwners(otnerOwners) external{
        address[] memory owners = new address[](otherOwner + 1)
        owners[otherOwner.length] = msg.sender;
        uint id = nextAccountId;
        for(uint idx; idx < owners.length; idx++){
            if(idx < owners.length - 1){
                owners[idx] = otherOwners[idx];
            }
            if(userAccounts[owners[idx]].length > 2){
                revert("Each user can have three accounts");
            }
            userAccounts[owners[idx]].push(id)
        }
        accounts[id].owners = owners;
        nextAccountId++;
        emit AccountCreated(owner,id,block.timestamp);
    }
    function requestWithdraw(uint accountId,uint amount) external accountOwner(accountId) sufficientBalance(accountId,amount){
        uint id  = nextWithdrawId;
        withDrawRequest storage request = accounts[accountId].withDrawRequest;
        request.user = msg.sender;
        request.amount = amount;
        nextWithdrawId++;
        emit(msg.sender,accountId,amount,block.timestamp)

    }
    function approveWithdraw(uint accountId, uint withdrawId) external  accountOwner(accountId){
        withDrawRequest storage request = accounts[accountId].withDrawRequests[withdrawId]
        request.approvals++;
        request.ownerApproved[msg.sender] = true;
        if(request.approvals == accounts[accountId].owners.length - 1){
            request.approved = true;
        }

    }
    function withdraw(uint accountId,uint withdrawId) external{

    }
    function getBalance(uint accountId) public view returns(uint){

    }
    function getOwner(uint accountId) public view returns(address[] memory){

    }
    function getAccounts() public view returns(uint[] memory){

    }
}
