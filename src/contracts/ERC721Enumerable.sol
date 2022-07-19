// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./interfaces/IERC721Enumerable.sol";

contract ERC721Enumerable is IERC721Enumerable, ERC721 {
    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;
    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;
    //mapping from tokenId to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("totalSupply(bytes4)") ^
                    keccak256("tokenByIndex(bytes4)") ^
                    keccak256("tokenOfOwnerByIndex(bytes4)")
            )
        );
    }

    function tokenByIndex(uint256 _index)
        public
        view
        override
        returns (uint256)
    {
        require(_index < totalSupply(), "global index is out of bounds!");
        return _allTokens[_index];
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index)
        public
        view
        override
        returns (uint256)
    {
        require(_index < balanceOf(_owner), "owner index is out of bounds!");
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

    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }
}
