// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';


contract KryptoBird is ERC721Connector{

    // array to store out nfts 
    string [] public kryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    constructor() ERC721Connector('KryptoBird','KBIRDZ'){
        
    }

    function mint(string memory _kryptoBird) public {
        require(!_kryptoBirdzExists[_kryptoBird] , 'ERC721 : Token already exists');
        //deprecated //uint _id = KryptoBirdz.push(_kryptoBird);

        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length-1;

        _mint(msg.sender, _id);

        _kryptoBirdzExists[_kryptoBird] = true ;
    }
}