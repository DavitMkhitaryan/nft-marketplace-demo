// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    Buliding out the minting functionality:
        a. nft to point to an address
        b. keep track of the token ids
        c. keep track of the token owner addresses to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log - contract address where it is being minted to, the id
*/

contract ERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);


    // Mapping from token id to owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _ownedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), 'ERC721: Minting to the zero address');
        require(!_exists(tokenId), 'ERC721: Token already minted');
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;

        // address(0) is default value for now, but it should be the contract address
        emit Transfer(address(0), to, tokenId);
    }

    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner != address(0), 'ERC721: Owner input address is zero address');
        return _ownedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns(address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'ERC721: Owner input address is zero address');
        return owner;
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Transferring to zero address');
        require(ownerOf(_tokenId) == _from, 'Trasnferring from not the owner of the token');
        
        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        _transferFrom(_from, _to, _tokenId);
    }

}