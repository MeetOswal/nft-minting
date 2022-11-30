// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721{

    mapping (uint256 => address) private _tokenOwner;
    mapping (address => uint256 ) private _OwnedTokensCount;
    mapping (uint256 => address) private _tokenApprovals;

    function balanceOf(address _owner) public override view returns(uint256){
        require(_owner != address(0), 'Owner for non-existent token');
        return _OwnedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external override view returns(address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0));
        return owner;
    }

    function _exists(uint256 tokenID) internal view returns(bool){
        address owner = _tokenOwner[tokenID];
        //return bool
        return owner != address(0);
    }

    function _mint(address _to, uint256 _tokenID) internal virtual {
        // requires that the address isnt zero
        require(_to != address(0), 'ERC721 : minting to zero address');
        // require that the token does not already exist
        require(!_exists(_tokenID), 'ERC721 : Token already minted');
        // we are adding a new address with a token id for minting
        _tokenOwner[_tokenID] = _to;
        // keeping track of each address that os minting and adding one to the address
        _OwnedTokensCount[_to] += 1;

        emit Transfer(address(0), _to, _tokenID);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenID)internal{
        require(_from != address(0), 'Given Address is faulty');
        require(_to != address(0),'Given Address is faulty');
        require(_tokenOwner[_tokenID] == _from ,'This Token Does not belong to the senders');

        _tokenOwner[_tokenID] = _to;
        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;

        emit Transfer(_from, _to, _tokenID);
    }

    function transferFrom(address _from, address _to, uint256 _tokenID) public override {
        require(isApprovedOwner(msg.sender, _tokenID));
        approve(_to, _tokenID);
        _transferFrom(_from, _to, _tokenID);
    }

    function approve(address _to, uint256 _tokenId)internal{
        address owner =  _tokenOwner[_tokenId];
        require(_to != owner, 'Error - Approval to current owner');
        require(msg.sender == owner, 'Current Caller is not the owner of the NFT');
        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOwner(address spender, uint256 tokenId)internal view returns(bool){
        require(_exists(tokenId), 'Token does not exist');
        address owner = _tokenOwner[tokenId];
        return(spender == owner);
    }
}