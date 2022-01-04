// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC1190.sol";

contract ERC1190Tradable is ERC1190 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => uint256) private _ownershipPrice;
    mapping(uint256 => uint256) private _rentalPrice;

    constructor(string memory name_, string memory symbol_)
        ERC1190(name_, symbol_)
    {}

    function mint(
        address player,
        string memory tokenURI,
        uint8 _royaltyForRental,
        uint8 _royaltyForOwnershipTransfer
    ) public returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        super._mint(player, newItemId);
        super._setRoyalties(
            newItemId,
            _royaltyForRental,
            _royaltyForOwnershipTransfer
        );

        return newItemId;
    }

    //     function setForSale(uint256 _tokenId) external {
    //     address owner = ownerOf(_tokenId);

    //     approve(address(this),_tokenId);

    //     _tokensForSale.push(_tokenId);
    //     // set the sale price etc

    //     emit Approval(owner, address(this), _tokenId);
    // }

    //     function buy(uint256 _tokenId) external payable {
    //         address buyer = msg.sender;
    //         uint payedPrice = msg.value;

    //         require(isValidToken(_tokenId));
    //         require(getApproved(_tokenId) == address(this));
    //         // require payedPrice >= salePrice

    //         // pay the seller
    //         // remove token from tokensForSale

    //         transferFrom(ownerOf(_tokenId), buyer, _tokenId);
    //     }

    function setOwnershipPrice(uint256 _tokenId, uint256 _priceInWei) external {
        require(!super._exists(_tokenId), "ERC1190: token already minted");
        _ownershipPrice[_tokenId] = _priceInWei;
    }

    function setRentalpPrice(uint256 _tokenId, uint256 _priceInWei) external {
        require(!super._exists(_tokenId), "ERC1190: token already minted");
        _rentalPrice[_tokenId] = _priceInWei;
    }

    function rentAsset(uint256 _tokenId, uint256 rentExpirationDateInMillis)
        external
        payable
    {
        require(!super._exists(_tokenId), "ERC1190: token already minted");
        require(_rentalPrice[_tokenId] > 0, "Non rentable asset");
        require(
            msg.value >= _rentalPrice[_tokenId],
            "The amount of wei sent is not sufficient"
        );

        address payable _owner = payable(super.ownerOf(_tokenId));
        address payable _creativeOwner = payable(
            super.creativeOwnerOf(_tokenId)
        );
        if (_owner == _creativeOwner) {
            address(_owner).transfer(msg.value);
        } else {
            uint8 royaltyForRental = super._royaltyForRental(_tokenId);
            address(_owner).transfer(
                (msg.value * (100 - royaltyForRental)) / 100
            );
            address(_creativeOwner).transfer(
                (msg.value * royaltyForRental) / 100
            );
        }
        super.rentAsset(msg.sender, _tokenId, rentExpirationDateInMillis);
    }

    function getOwnershipLicense(uint256 _tokenId) external payable {
        require(!super._exists(_tokenId), "ERC1190: token already minted");
        require(
            _ownershipPrice[_tokenId] > 0,
            "Ownership license non transferable"
        );
        require(
            msg.value >= _ownershipPrice[_tokenId],
            "The amount of wei sent is not sufficient"
        );
        require(
            msg.sender != address(0),
            "Ownership transfers to the zero address"
        );

        address payable _owner = payable(super.ownerOf(_tokenId));
        address payable _creativeOwner = payable(
            super.creativeOwnerOf(_tokenId)
        );

        if (_owner == _creativeOwner) {
            address(_owner).transfer(msg.value);
        } else {
            uint8 royaltyForOwnershipTransfer = super
                ._royaltyForOwnershipTransfer(_tokenId);
            address(_owner).transfer(
                (msg.value * (100 - royaltyForOwnershipTransfer)) / 100
            );
            address(_creativeOwner).transfer(
                (msg.value * royaltyForOwnershipTransfer) / 100
            );
        }

        super.transferOwnershipLicenseFrom(_owner, msg.sender, _tokenId);
    }

    function transferCreativeLicense(uint256 _tokenId, address to) external {
        address _creativeOwner = super.creativeOwnerOf(_tokenId);

        require(
            to != address(0),
            "Creative license transfers to the zero address"
        );
        require(
            msg.sender == _creativeOwner,
            "Sender does not have the Creative License "
        );

        //address payable _owner = payable(super.ownerOf(_tokenId));

        super.transferCreativeLicenseFrom(msg.sender, to, _tokenId);
    }
}
