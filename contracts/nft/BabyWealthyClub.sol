// SPDX-License-Identifier: MIT

pragma solidity 0.7.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BabyWealthyClub is ERC721("Baby Wealthy Club", "BWC"), Ownable {
    
    mapping(address => bool) public isMinner;

    event Mint(address account, uint256 tokenId);
    event NewMinner(address account);
    event DelMinner(address account);

    function addMinner(address _minner) external onlyOwner {
        require(
            _minner != address(0),
            "BabyWealthyClub: minner is zero address"
        );
        isMinner[_minner] = true;
        emit NewMinner(_minner);
    }

    function delMinner(address _minner) external onlyOwner {
        require(
            _minner != address(0),
            "BabyWealthyClub: minner is the zero address"
        );
        isMinner[_minner] = false;
        emit DelMinner(_minner);
    }

    function mint(address _recipient) public onlyMinner {
        require(
            _recipient != address(0),
            "BabyWealthyClub: recipient is zero address"
        );
        uint256 _tokenId = totalSupply() + 1;
        _mint(_recipient, _tokenId);
        emit Mint(_recipient, _tokenId);
    }

    function batchMint(address[] memory _recipients) external onlyMinner {
        for (uint256 i = 0; i != _recipients.length; i++) {
            mint(_recipients[i]);
        }
    }

    function setBaseURI(string memory baseUri) external onlyOwner {
        _setBaseURI(baseUri);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        string memory uri = super.tokenURI(tokenId);
        return string(abi.encodePacked(uri, ".json"));
    }

    modifier onlyMinner() {
        require(
            isMinner[msg.sender],
            "BabyWealthyClub: caller is not the minner"
        );
        _;
    }
}
