// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ERC1190.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @dev Implementation of ERC1190 with payable methods.
 */
contract ERC1190Tradable is ERC1190 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // The price in wei of each token that can be owned.
    mapping(uint256 => uint256) private _ownershipPrice;

    // The price in wei of each token that can be rented.
    mapping(uint256 => uint256) private _rentalPrice;

    /**
     * @dev See {ERC1190-constructor}.
     */
    constructor(string memory tokenName, string memory tokenSymbol)
        ERC1190(tokenName, tokenSymbol)
    {}

    /**
     * @dev Generates a new token and assigns its ownership and creative
     * license to `creator`.
     * The royalties are set via `royaltyForRental` and `royaltyForOwnershipTransfer`.
     */
    function mint(
        address creator,
        uint8 royaltyForRental,
        uint8 royaltyForOwnershipTransfer
    ) external returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        super._mint(creator, newItemId);
        super._setRoyalties(
            newItemId,
            royaltyForRental,
            royaltyForOwnershipTransfer
        );

        return newItemId;
    }

    /**
     * @dev Sets the price for acquiring property of the ownership license of token
     * `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `priceInWei` must be greater than 0.
     */
    function setOwnershipLicensePrice(uint256 tokenId, uint256 priceInWei) external {
        require(
            super._exists(tokenId),
            "ERC1190Tradable: The token does not exist."
        );

        require(
            priceInWei > 0,
            "ERC1190Tradable: The ownership license cost must be greater than 0."
        );

        _ownershipPrice[tokenId] = priceInWei;
    }

    /**
     * @dev Sets the price for renting `tokenId` for 1 second.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `priceInWei` must be greater than 0.
     */
    function setRentalPrice(uint256 tokenId, uint256 priceInWei) external {
        require(
            super._exists(tokenId),
            "ERC1190Tradable: The token does not exist."
        );

        require(
            priceInWei > 0,
            "ERC1190Tradable: The rental cost per second must be greater than 0."
        );

        _rentalPrice[tokenId] = priceInWei;
    }

    /**
     * @dev Rents the token `tokenId` for a total amount of `rentExpirationDateInMillis` ms.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - A rental price must have been set via {setRentalPrice}.
     * - `rentExpirationDateInMillis` should correspond to a future date.
     * - the sent money should be enough to cover the renting expenses.
     */
    function rentAsset(uint256 tokenId, uint256 rentExpirationDateInMillis)
        external
        payable
    {
        require(
            super._exists(tokenId),
            "ERC1190Tradable: The token does not exist."
        );

        require(
            _rentalPrice[tokenId] > 0,
            "ERC1190Tradable: The asset related to this token is not rentable."
        );

        uint256 rentTimeInSeconds = (rentExpirationDateInMillis / 1000) -
            block.timestamp;

        require(
            rentTimeInSeconds > 0,
            "ERC1190Tradable: The rental time must be positive."
        );

        uint256 rentalTotalPrice = rentTimeInSeconds * _rentalPrice[tokenId];

        require(
            msg.value >= rentalTotalPrice,
            "ERC1190Tradable: The amount of wei sent is not sufficient to cover the rent expenses."
        );

        address payable owner = payable(super.ownerOf(tokenId));
        address payable creativeOwner = payable(super.creativeOwnerOf(tokenId));

        if (owner == creativeOwner) {
            owner.transfer(msg.value);
        } else {
            uint8 royalty = super._royaltyForRental(tokenId);

            owner.transfer((msg.value * (100 - royalty)) / 100);
            creativeOwner.transfer((msg.value * royalty) / 100);
        }

        super.rentAsset(
            super._msgSender(),
            tokenId,
            rentExpirationDateInMillis
        );
    }

    /**
     * @dev Transfers the ownership license from the current owner to the sender of the request.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - A ownership license price must have been set via {setOwnershipLicensePrice}.
     * - the sent money should be enough to cover the license expense.
     */
    function obtainOwnershipLicense(uint256 tokenId) external payable {
        require(
            super._exists(tokenId),
            "ERC1190Tradable: The token does not exist."
        );

        require(
            _ownershipPrice[tokenId] > 0,
            "ERC1190Tradable: The ownership license of this token cannot be transfered."
        );

        require(
            msg.value >= _ownershipPrice[tokenId],
            "ERC1190Tradable: The amount of wei sent is not sufficient for obtaining the ownership license of this token."
        );

        require(
            super._msgSender() != address(0),
            "ERC1190Tradable: Cannot transfer the ownership to the zero address."
        );

        address payable owner = payable(super.ownerOf(tokenId));
        address payable creativeOwner = payable(super.creativeOwnerOf(tokenId));

        if (owner == creativeOwner) {
            owner.transfer(msg.value);
        } else {
            uint8 royalty = super._royaltyForOwnershipTransfer(tokenId);
            owner.transfer((msg.value * (100 - royalty)) / 100);
            creativeOwner.transfer((msg.value * royalty) / 100);
        }

        super.transferOwnershipLicense(owner, super._msgSender(), tokenId);
    }

    /**
     * @dev Transfers the creative license from the current creative owner to the account `to`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - the sender of the request must be the creative owner.
     * - the receiver account `to` must not be the zero address.
     */
    function transferCreativeLicense(uint256 tokenId, address to) external {
        require(
            to != address(0),
            "ERC1190Tradable: Cannot transfer the Creative license to the zero address."
        );

        address creativeOwner = super.creativeOwnerOf(tokenId);

        require(
            super._msgSender() == creativeOwner,
            "ERC1190Tradable: The sender does not own the creative license."
        );

        super.transferCreativeLicense(creativeOwner, to, tokenId);
    }
}