// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumarable is ERC721 {

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;
    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;
    //mapping from tokenId to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    function tokenByIndex(uint256 _index) public view returns(uint256) {
        require(_index < totalSupply(), 'global index is out of bounds!');
        return _allTokens[_index];
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns(uint256) {
        require(_index < balanceOf(_owner), 'owner index is out of bounds!');
        return _ownedTokens[_owner][_index];
    }


    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        // Add tokens to the owner
        // Add tokens to total supply / allTokens
        _addTokensToAllTokenEnumaration(tokenId);
        _addTokensToOwnerEnumaration(to, tokenId);
    }

    function _addTokensToAllTokenEnumaration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumaration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function totalSupply() public view returns(uint256) {
        return _allTokens.length;
    }
}