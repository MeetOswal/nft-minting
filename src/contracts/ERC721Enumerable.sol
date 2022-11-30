// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumerable is ERC721{
    uint256[] private _allTokens;

    mapping(uint256 => uint256) private  _allTokensIndex;
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;

    //return the total supply of tht _allToken array
    function totalSupply() public view returns(uint256){
        return _allTokens.length;
    }

    function _mint(address _to, uint256 _tokenID)internal override(ERC721){
        super._mint(_to , _tokenID);

        _addTokensToAllTokensEnumeration(_tokenID);
        _addTokensToOwnerEnumeration(_to, _tokenID);

    }

    //add tokens to _allTokens array and set the position of the mapp as the token id
    //and the value as the length of array before adding the new token
    function _addTokensToAllTokensEnumeration(uint256 tokenId) private{
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId)private{
        //add address and token id to the _ownedTokens
        //ownedTokenIndex Token IDs set to address of ownedTokens position
        //execute the function with minting
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function tokenByIndex(uint256 index) public view returns(uint256){
        require(index < totalSupply(), 'global index is out of bound!');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index)public view returns(uint256){
        require(index < balanceOf(owner),'owner index is out of bound!');
        return _ownedTokens[owner][index];
    }
}