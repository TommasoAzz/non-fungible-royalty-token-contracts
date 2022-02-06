// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC1190.sol";
import "./IERC1190Metadata.sol";
import "./IERC1190OwnershipLicenseReceiver.sol";
import "./IERC1190CreativeLicenseReceiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

/**
 * @dev Implementation of IERC1190.sol and IERC1190Metadata.sol.
 */
contract ERC1190 is Context, ERC165, IERC1190, IERC1190Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping from token ID to creative owner address
    mapping(uint256 => address) private _creativeOwners;

    // Mapping from token ID to renters address
    mapping(uint256 => mapping(address => uint256)) private _renters;

    // Mapping from token ID to renters addresses
    mapping(uint256 => address[]) private _renterLists;

    // Mapping owner address to token count
    mapping(address => uint256) private _ownerBalances;

    // Mapping creative owner address to token count
    mapping(address => uint256) private _creativeOwnerBalances;

    // Mapping renter address to token count
    mapping(address => uint256) private _renterBalances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from token ID to rotyaltyForRental
    mapping(uint256 => uint8) private _royaltiesForRental;

    // Mapping from token ID to rotyaltyForOwnershipTransfer
    mapping(uint256 => uint8) private _royaltiesForOwnershipTransfer;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Mapping from token to file.
    mapping(uint256 => string) private _files;

    /**
     * @dev Initializes the contract by setting a `tokenName` and a `tokenSymbol` to the token collection.
     */
    constructor(string memory tokenName, string memory tokenSymbol) {
        _name = tokenName;
        _symbol = tokenSymbol;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC165, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC1190).interfaceId ||
            interfaceId == type(IERC1190Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC1190-balanceOfOwner}.
     */
    function balanceOfOwner(address owner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            owner != address(0),
            "ERC1190: owner cannot be the zero address."
        );

        return _ownerBalances[owner];
    }

    /**
     * @dev See {IERC1190-balanceOfCreativeOwner}.
     */
    function balanceOfCreativeOwner(address creativeOwner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            creativeOwner != address(0),
            "ERC1190: creativeOwner cannot be the zero address."
        );

        return _creativeOwnerBalances[creativeOwner];
    }

    /**
     * @dev See {IERC1190-balanceOfRenter}.
     */
    function balanceOfRenter(address renter)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            renter != address(0),
            "ERC1190: renter cannot be the zero address."
        );

        return _renterBalances[renter];
    }

    /**
     * @dev See {IERC1190-ownerOf}.
     */
    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address owner = _owners[tokenId];
        require(
            owner != address(0),
            "ERC1190: Nobody has ownership over tokenId."
        );

        return owner;
    }

    /**
     * @dev See {IERC1190-creativeOwnerOf}.
     */
    function creativeOwnerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address creativeOwner = _creativeOwners[tokenId];
        require(
            creativeOwner != address(0),
            "ERC1190: Nobody has creative ownership over tokenId."
        );

        return creativeOwner;
    }

    /**
     * @dev See {IERC1190-rentersOf}.
     */
    function rentersOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address[] memory)
    {
        return _renterLists[tokenId];
    }

    /**
     * @dev See {IERC1190Metadata-name}.
     */
    function name() external view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC1190Metadata-symbol}.
     */
    function symbol() external view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return (_owners[tokenId] != address(0) &&
            _creativeOwners[tokenId] != address(0));
    }

    /**
     * @dev See {IERC1190Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        external
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "ERC1190: The token does not exist.");
        require(
            bytes(_files[tokenId]).length > 0,
            "ERC1190: No file associated to the token."
        );

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, _files[tokenId]))
                : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC1190-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC1190.ownerOf(tokenId);
        address creativeOwner = ERC1190.creativeOwnerOf(tokenId);
        require(to != owner, "ERC1190: Cannot approve the current owner.");
        require(
            to != creativeOwner,
            "ERC1190: Cannot approve the current creative owner."
        );

        require(
            _msgSender() == owner ||
                _msgSender() == creativeOwner ||
                isApprovedForAll(owner, _msgSender()) ||
                isApprovedForAll(creativeOwner, _msgSender()),
            "ERC1190: The sender is neither the (creative) owner of the token nor approved to manage it."
        );

        _approve(owner, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`.
     *
     * Emits a {Approval} event.
     */
    function _approve(
        address owner,
        address to,
        uint256 tokenId
    ) internal virtual {
        _tokenApprovals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev See {IERC1190-getApproved}.
     */
    function getApproved(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        require(_exists(tokenId), "ERC1190: The token does not exist.");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC1190-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens.
     *
     * Emits a {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(
            owner != operator,
            "ERC1190: The owner cannot approve theirself."
        );

        _operatorApprovals[owner][operator] = approved;

        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev See {IERC1190-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev Returns whether `account` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address account, uint256 tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        require(_exists(tokenId), "ERC1190: The token does not exist.");
        address owner = ERC1190.ownerOf(tokenId);

        return (account == owner ||
            getApproved(tokenId) == account ||
            isApprovedForAll(owner, account));
    }

    /**
     * @dev Returns whether `account` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrCreativeOwner(address account, uint256 tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        require(_exists(tokenId), "ERC1190: The token does not exist.");
        address creativeOwner = ERC1190.creativeOwnerOf(tokenId);

        return (account == creativeOwner ||
            getApproved(tokenId) == account ||
            isApprovedForAll(creativeOwner, account));
    }

    /**
     * @dev See {IERC1190-transferOwnershipLicense}.
     */
    function transferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: The sender is neither the owner nor approved to manage the token."
        );

        _transferOwnershipLicense(from, to, tokenId);
    }

    /**
     * @dev See {transferOwnershipLicense}.
     */
    function _transferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        address owner = ERC1190.ownerOf(tokenId);
        require(
            owner == from,
            "ERC1190: Cannot transfer the ownership license if it is not owned."
        );
        require(
            to != address(0),
            "ERC1190: Cannot transfer to the zero address."
        );

        // Clear approvals from the previous owner
        _approve(owner, address(0), tokenId);

        _ownerBalances[from] -= 1;
        _ownerBalances[to] += 1;
        _owners[tokenId] = to;

        emit TransferOwnershipLicense(from, to, tokenId);
    }

    /**
     * @dev See {IERC1190-safeTransferOwnershipLicense}.
     */
    function safeTransferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferOwnershipLicense(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC1190-safeTransferOwnershipLicense}.
     */
    function safeTransferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: The sender is neither the owner nor approved to manage the token."
        );

        _safeTransferOwnershipLicense(from, to, tokenId, data);
    }

    /**
     * @dev See {safeTransferOwnershipLicense}.
     */
    function _safeTransferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _transferOwnershipLicense(from, to, tokenId);

        require(
            _checkOnERC1190OwnershipLicenseReceived(from, to, tokenId, data),
            "ERC1190: Transfer to contract not implementing IERC1190Receiver."
        );
    }

    /**
     * @dev See {IERC1190-transferCreativeLicense}.
     */
    function transferCreativeLicense(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(
            _isApprovedOrCreativeOwner(_msgSender(), tokenId),
            "ERC1190: The sender is neither the creative owner nor approved to manage the token."
        );

        _transferCreativeLicense(from, to, tokenId);
    }

    /**
     * @dev See {transferCreativeLicense}.
     */
    function _transferCreativeLicense(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        address creativeOwner = ERC1190.creativeOwnerOf(tokenId);
        require(
            creativeOwner == from,
            "ERC1190: Cannot transfer the ownership license if it is not owned."
        );
        require(
            to != address(0),
            "ERC1190: Cannot transfer to the zero address."
        );

        // Clear approvals from the previous owner
        _approve(creativeOwner, address(0), tokenId);

        _creativeOwnerBalances[from] -= 1;
        _creativeOwnerBalances[to] += 1;
        _creativeOwners[tokenId] = to;

        emit TransferCreativeLicense(from, to, tokenId);
    }

    /**
     * @dev See {IERC1190-safeTransferCreativeLicense}.
     */
    function safeTransferCreativeLicense(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferCreativeLicense(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC1190-safeTransferCreativeLicense}.
     */
    function safeTransferCreativeLicense(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(
            _isApprovedOrCreativeOwner(_msgSender(), tokenId),
            "ERC1190: The sender is neither the creative owner nor approved to manage the token."
        );

        _safeTransferCreativeLicense(from, to, tokenId, data);
    }

    /**
     * @dev See {safeTransferCreativeLicense}.
     */
    function _safeTransferCreativeLicense(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _transferCreativeLicense(from, to, tokenId);

        require(
            _checkOnERC1190CreativeLicenseReceived(from, to, tokenId, data),
            "ERC1190: Transfer to contract not implementing IERC1190Receiver."
        );
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC1190Receiver-onERC1190OwnershipLicenseReceived},
     * which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {_safeMint(address,uint256)}, with an additional `data` parameter which is
     * forwarded in {IERC1190Receiver-onERC1190OwnershipLicenseReceived} and
     * {IERC1190Receiver-onERC1190CreativeLicenseReceived} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);

        require(
            _checkOnERC1190OwnershipLicenseReceived(
                address(0),
                to,
                tokenId,
                data
            ),
            "ERC1190: Transfer to contract not implementing IERC1190Receiver."
        );

        require(
            _checkOnERC1190CreativeLicenseReceived(
                address(0),
                to,
                tokenId,
                data
            ),
            "ERC1190: Transfer to contract not implementing IERC1190Receiver."
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC1190: to cannot be the zero address.");
        require(!_exists(tokenId), "ERC1190: The token already exists.");

        _ownerBalances[to] += 1;
        _creativeOwnerBalances[to] += 1;
        _owners[tokenId] = to;
        _creativeOwners[tokenId] = to;

        emit TransferOwnershipLicense(address(0), to, tokenId);
        emit TransferCreativeLicense(address(0), to, tokenId);
    }

    function _associateFile(uint256 tokenId, string calldata file)
        internal
        virtual
    {
        require(_exists(tokenId), "ERC1190: The token does not exist.");

        _files[tokenId] = file;
    }

    /**
     * @dev Set royalties for rental and royalties for ownership transfer.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `rentalRoyalty` must be in [0,100].
     * - `ownershipTransferRoyalty` must be in [0,100].
     */
    function _setRoyalties(
        uint256 tokenId,
        uint8 rentalRoyalty,
        uint8 ownershipTransferRoyalty
    ) internal virtual {
        require(_exists(tokenId), "ERC1190: The token does not exist.");

        require(
            0 <= rentalRoyalty && rentalRoyalty <= 100,
            "ERC1190: Royalty for rental out of range [0,100]."
        );

        require(
            0 <= ownershipTransferRoyalty && ownershipTransferRoyalty <= 100,
            "ERC1190: Royalty for ownership transfer out of range [0,100]."
        );

        _royaltiesForRental[tokenId] = rentalRoyalty;
        _royaltiesForOwnershipTransfer[tokenId] = ownershipTransferRoyalty;
    }

    function royaltyForRental(uint256 _tokenId)
        external
        view
        virtual
        returns (uint8)
    {
        return _royaltyForRental(_tokenId);
    }

    function _royaltyForRental(uint256 _tokenId)
        internal
        view
        virtual
        returns (uint8)
    {
        require(_exists(_tokenId), "ERC1190: The token does not exist.");

        return _royaltiesForRental[_tokenId];
    }

    function royaltyForOwnershipTransfer(uint256 _tokenId)
        external
        view
        virtual
        returns (uint8)
    {
        return _royaltyForOwnershipTransfer(_tokenId);
    }

    function _royaltyForOwnershipTransfer(uint256 _tokenId)
        internal
        view
        virtual
        returns (uint8)
    {
        require(_exists(_tokenId), "ERC1190: The token does not exist.");

        return _royaltiesForOwnershipTransfer[_tokenId];
    }

    /**
     * @dev See {IERC1190-rentAsset}.
     */
    function rentAsset(
        address renter,
        uint256 tokenId,
        uint256 rentExpirationDateInMillis
    ) public virtual override {
        _rentAsset(renter, tokenId, rentExpirationDateInMillis);
    }

    /**
     * @dev See {rentAsset}.
     */
    function _rentAsset(
        address renter,
        uint256 tokenId,
        uint256 rentExpirationDateInMillis
    ) internal virtual {
        require(
            renter != address(0),
            "ERC1190: renter cannot be the zero address."
        );

        require(_exists(tokenId), "ERC1190: The token does not exist.");

        _renters[tokenId][renter] = rentExpirationDateInMillis;
        _renterLists[tokenId].push(renter);
        _renterBalances[renter] += 1;

        emit AssetRented(renter, tokenId, rentExpirationDateInMillis);
    }

    /**
     * @dev See {IERC1190-updateEndRentalDate}.
     */
    function updateEndRentalDate(uint256 tokenId, uint256 currentDate, address renter)
        public
        virtual
        override
        returns (uint256)
    {
        require(_exists(tokenId), "ERC1190: The token does not exist.");

        require(
            renter != address(0),
            "ERC1190: renter cannot be the zero address."
        );

        require(
            _renters[tokenId][renter] != 0,
            "ERC1190: The renter has not rented the token."
        );

        uint256 expiration = _renters[tokenId][renter];

        if (expiration < currentDate) {
            // block.timestamp is the current date and time.
            delete _renters[tokenId][renter];
            bool stop = false;
            for (
                uint256 i = 0;
                i < _renterLists[tokenId].length && !stop;
                i++
            ) {
                if (_renterLists[tokenId][i] == renter) {
                    // Moving the last item inside the position of the item to remove, popping the last one.
                    _renterLists[tokenId][i] = _renterLists[tokenId][
                        _renterLists[tokenId].length - 1
                    ];
                    _renterLists[tokenId].pop();
                    stop = true;
                }
            }
            _renterBalances[renter] -= 1;
        }

        return _renters[tokenId][renter];
    }

    /**
     * @dev See {IERC1190-getRentalDate}.
     */
    function getRentalDate(uint256 tokenId, address renter)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(_exists(tokenId), "ERC1190: The token does not exist.");

        require(
            renter != address(0),
            "ERC1190: renter cannot be the zero address."
        );

        return _renters[tokenId][renter];
    }

    /**
     * @dev Internal function to invoke {IERC1190Receiver-onERC1190CreativeLicenseReceived} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC1190CreativeLicenseReceived(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC1190CreativeLicenseReceiver(to)
                    .onERC1190CreativeLicenseReceived(
                        _msgSender(),
                        from,
                        tokenId,
                        data
                    )
            returns (bytes4 retval) {
                return
                    retval ==
                    IERC1190CreativeLicenseReceiver
                        .onERC1190CreativeLicenseReceived
                        .selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC1190: Tried transfer to contract not implementing IERC1190CreativeLicenseReceiver."
                    );
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Internal function to invoke {IERC1190Receiver-onERC1190OwnershipLicenseReceived} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC1190OwnershipLicenseReceived(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC1190OwnershipLicenseReceiver(to)
                    .onERC1190OwnershipLicenseReceived(
                        _msgSender(),
                        from,
                        tokenId,
                        data
                    )
            returns (bytes4 retval) {
                return
                    retval ==
                    IERC1190OwnershipLicenseReceiver
                        .onERC1190OwnershipLicenseReceived
                        .selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC1190: Transfer to contract not implementing IERC1190Receiver."
                    );
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
}
