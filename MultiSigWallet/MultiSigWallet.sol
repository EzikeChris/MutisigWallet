// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;


contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount, uint balance)
    // Event to notify users of a deposit on the wallet/contract
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        uint value,
        address indexed to,
        bytes data,
    );
    // event to notify users on a submitted transaction by one of the owners
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    // confirmation of transaction by two or three of the signers
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);
    // after confirmation transaction will be executed by signers
    event RevokeTransaction(address indexed owner, uint indexed txIndex);
    // RevokeTransaction by the transaction sender
    address [] public owners;
    mapping(address => bool) public isOwner;
    // an array of owners of the multisig wallet
    uint public numConfirmationRequired;
    // number of confirmation required for a transaction to pass/ executed
    struct Transaction {
        address to;
        // address the transaction is sent to
        bool executed;
        // Check if the transaction is executed of not
        uint numConfirmation;
        bytes data;
        // if we are calling another contract we stored the transaction data which would be sent to the contract
        uint value;
        // amount of ethers sent to the address
        mapping(address => bool) isConfirmed;
        // when an owner or owners approve a transaction its store to bool(true/false) if it was isconfirmed or not 
        uint numConfirmations;
        ///Number of approvals stored in a transaction///
    }
    // Once the submit traction function has been called, you then create a transaction array or list to show the transaction list
    Transaction[] public transactions;
    // an array of transactions created

    constructor(address [] memory _owners, uint _numConfirmationRequired) public {
  require(_owners.length > 0, "Owner is Required");
  require(_numConfirmationRequired > 0 && _numConfirmationRequired <= _owners.length,
  "Invalid Number of Required Confirmations"
  );
  for (uint i = 0; i < _owners.length; i++) {
      address owner = _owners[i];
      require(owner != address(0), "invalid owner");
      require(!isOwner[owner], "owner not unique);

      isOwner[owner] = true;
      owners.push(owner);
      numConfirmationsRequired = _numConfirmationRequired;   
  }

    }

    modifier OnlyOwner() {
        require(isOwner[msg.sender],  "Not Owner");
        _;
    }

    function submitTransaction(address _to, uint _value, byte memory _data) public OnlyOwner {
        uint txIndex = transactions.length;
        transaction.push(Transactions({
            to: _to;
            data: _data,
            executed: false,
            numConfirmations: 0
        }));
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
     
        }

        modifier txExist(uint _txIndex) {
            // check for the transaction number based on transaction index
            require(_txIndex < transactions.length, "tx does not exist");
            _; 
        }
        modifier notExecuted(uint _txIndex) {
            // a transaction must be not be executed before confirmation
             require(!transaction[_txIndex].executed, "transaction executed already")
             _;
         }   
         modifier notConfirmed(uint _txIndex) {
             // a transaction cannot be confirmed before being confirmed(you cant confirm one transaction twice)
             require(!transaction[_txIndex].isConfirmed[msg.sender], "transaction confirmed")
             _;
         }
    
    function confirmTraction(uint _txIndex) 
    public 
    // function behaviour public
    OnlyOwner 
    // only owner can confirm the transaction
    txExist(_txIndex)
    // OnlyOwner can confirm an existing transaction(only an existing transaction can be confirmed)
    notExecuted(_txIndex)
    // only unexecuted transactions can be confirmed
    notConfirmed(_txIndex)
    // a transaction can only be confirmed once
     {
         Transaction storage transaction = transactions[_txIndex];
         transaction.isConfirmed[msg.sender] = true;
         // increment number of confirmation +1
         transaction.numConfirmations += 1;
         emit ConfirmTransaction(msg.sender, _txIndex);
    }
    function executeTransaction(){}





    
    function revokeTransaction() {}
  
}













































// pragma solidity >=0.4.0 <0.9.0;
// contract MultiSigWallet {
//     event deposit(address sender, uint amount, uint balance);
//     event SubmitTransaction(address indexed owner, 
//     uint indexed txIndex,
//     address  indexed to,
//     bytes data,
//     uint value
//     );
//     event ConfirmTransaction(address indexed owner, uint indexed txIndex);
//     event ExecuteTransaction(address indexed owner, uint indexed txIndex);
//     event RevokeTransaction(address indexed owner, uint indexed txIndex);

//     uint public numConfirmationsRequired;
//     mapping(address => bool) public isOwner;
//     address[] public owners;

//     struct Transaction {
//         address to;
//         bytes data;
//         uint value;
//         mapping(address => bool)  isConfirmed;
//         uint numConfirmations;
//     }

//     Transaction[] public transactions;

//     constructor (address [] memory _owners, uint _numConfirmationRequired ) public {
//         require(_owners.length > 0, "Owner is Required");
//         require(_numConfirmationRequired > 0 && _numConfirmationRequired <= _owners.length,
//         "OWNER IS NOT SET"
//         );

//         for (var i = 0; i < owners.length; i++)  {
//       address owner = _owners[i];
//       require(owner != address(0), "invalid owner");
//       require(!isOwner[owner], "owner not unique);

//       isOwner[owner] = true;
//       owners.push(owner);
//       numConfirmationsRequired = _numConfirmationRequired;   
//   }
        
//     }

//     modifier OnlyOwner() {
//         require(isOwner[msg.sender], "Not Owner");
//         _;
//     }

//     function submitTransaction(address _to, uint value, bytes _data) public OnlyOwner {
//         uint txIndex = transactions.length;
//         transactions.push(Transaction({
//             to: _to;
//             data: _data,
//             executed: false,
//             numConfirmations: 0
//         }));
//         emit SubmitTransaction(msg.sender, _txIndex, _to, _value, _data);
//     }

// }