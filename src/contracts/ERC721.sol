// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";
import "./libraries/Counters.sol";

/*
    Buliding out the minting functionality:
        a. nft to point to an address
        b. keep track of the token ids
        c. keep track of the token owner addresses to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log - contract address where it is being minted to, the id
*/

contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    // Mapping from token id to owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    // mapping(address => uint256) private _ownedTokensCount;
    mapping(address => Counters.Counter) private _ownedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("transferFrom(bytes4)")
            )
        );
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: Minting to the zero address");
        require(!_exists(tokenId), "ERC721: Token already minted");
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment();

        // address(0) is default value for now, but it should be the contract address
        emit Transfer(address(0), to, tokenId);
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        require(
            _owner != address(0),
            "ERC721: Owner input address is zero address"
        );
        return _ownedTokensCount[_owner].current();
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(
            owner != address(0),
            "ERC721: Owner input address is zero address"
        );
        return owner;
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(_to != address(0), "Transferring to zero address");
        require(
            ownerOf(_tokenId) == _from,
            "Trasnferring from not the owner of the token"
        );

        _ownedTokensCount[_from].decrement();
        _ownedTokensCount[_to].increment();

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        _transferFrom(_from, _to, _tokenId);
    }
}
