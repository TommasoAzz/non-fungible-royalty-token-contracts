// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC1190.sol";
import "./IERC1190Receiver.sol";
import "./IERC1190Metadata.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

/**
 * @dev Implementation of IERC1190.sol, including the Metadata extension.
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

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
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
            "ERC1190: owner balance query for the zero address"
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
            "ERC1190: creative owner balance query for the zero address"
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
            "ERC1190: renter balance query for the zero address"
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
            "ERC1190: owner query for nonexistent token"
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
            "ERC1190: creative owner query for nonexistent token"
        );
        return creativeOwner;
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
     * @dev See {IERC1190Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        external
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC1190Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
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
        require(to != owner, "ERC1190: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC1190: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC1190.ownerOf(tokenId), to, tokenId);
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
        require(
            _exists(tokenId),
            "ERC1190: approved query for nonexistent token"
        );

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
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits a {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC1190: approve to caller");
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
     * @dev See {IERC1190-transferOwnershipLicenseFrom}.
     */
    function transferOwnershipLicenseFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: transfer caller is not owner nor approved"
        );

        _transferOwnershipLicense(from, to, tokenId);
    }

    /**
     * @dev See {IERC1190-safeTransferOwnershipLicenseFrom}.
     */
    function safeTransferOwnershipLicenseFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferOwnershipLicenseFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC1190-safeTransferOwnershipLicenseFrom}.
     */
    function safeTransferOwnershipLicenseFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: transfer caller is not owner nor approved"
        );
        _safeTransferOwnershipLicense(from, to, tokenId, _data);
    }

    /**
     * @dev See {transferOwnershipLicenseFrom}.
     */
    function _transferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(
            ERC1190.ownerOf(tokenId) == from,
            "ERC1190: transfer of token that is not own"
        );
        require(to != address(0), "ERC1190: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _ownerBalances[from] -= 1;
        _ownerBalances[to] += 1;
        _owners[tokenId] = to;

        emit TransferOwnershipLicense(from, to, tokenId);
    }

    /**
     * @dev See {safeTransferOwnershipLicenseFrom}
     */
    function _safeTransferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transferOwnershipLicense(from, to, tokenId);
        require(
            _checkOnERC1190OwnershipLicenseReceived(from, to, tokenId, _data),
            "ERC1190: transfer to non ERC1190Receiver implementer"
        );
    }

    /**
     * @dev See {IERC1190-transferFrom}.
     */
    function transferCreativeLicenseFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: transfer caller is not owner nor approved"
        );

        _transferCreativeLicense(from, to, tokenId);
    }

    /**
     * @dev See {IERC1190-safeTransferFrom}.
     */
    function safeTransferCreativeLicenseFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferCreativeLicenseFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC1190-safeCreativeLicenseTransferFrom}.
     */
    function safeTransferCreativeLicenseFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: transfer caller is not owner nor approved"
        );
        _safeTransferCreativeLicense(from, to, tokenId, _data);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        require(
            _exists(tokenId),
            "ERC1190: operator query for nonexistent token"
        );
        address owner = ERC1190.ownerOf(tokenId);
        return (spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
    }

    /**
     * @dev See {transferCreativeLicenseFrom}.
     */
    function _transferCreativeLicense(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(
            ERC1190.creativeOwnerOf(tokenId) == from,
            "ERC1190: transfer of token that is not own"
        );
        require(to != address(0), "ERC1190: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _creativeOwnerBalances[from] -= 1;
        _creativeOwnerBalances[to] += 1;
        _creativeOwners[tokenId] = to;

        emit TransferCreativeLicense(from, to, tokenId);
    }

    /**
     * @dev See {safeCreativeLicenseTransferFrom}.
     */
    function _safeTransferCreativeLicense(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transferCreativeLicense(from, to, tokenId);
        require(
            _checkOnERC1190CreativeLicenseReceived(from, to, tokenId, _data),
            "ERC1190: transfer to non ERC1190Receiver implementer"
        );
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return (_owners[tokenId] != address(0) ||
            _creativeOwners[tokenId] != address(0));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC1190Receiver-onERC1190Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC1190-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC1190Receiver-onERC1190Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC1190OwnershipLicenseReceived(
                address(0),
                to,
                tokenId,
                _data
            ),
            "ERC1190: transfer to non ERC1190Receiver implementer"
        );
        require(
            _checkOnERC1190CreativeLicenseReceived(
                address(0),
                to,
                tokenId,
                _data
            ),
            "ERC1190: transfer to non ERC1190Receiver implementer"
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
        require(to != address(0), "ERC1190: mint to the zero address");
        require(!_exists(tokenId), "ERC1190: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _ownerBalances[to] += 1;
        _creativeOwnerBalances[to] += 1;
        _owners[tokenId] = to;
        _creativeOwners[tokenId] = to;

        emit TransferOwnershipLicense(address(0), to, tokenId);
        emit TransferCreativeLicense(address(0), to, tokenId);
    }

    /**
     * @dev Set royalties for rental and royalties for ownership transfer.
     *
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `royaltyForRental' must be in [0,100]
     * -'royaltyForOwnershipTransfer' must be in [0,100]
     */
    function _setRoyalties(
        uint256 _tokenId,
        uint8 _royaltyForRental,
        uint8 _royaltyForOwnershipTransfer
    ) internal virtual {
        require(!_exists(_tokenId), "ERC1190: token already minted");
        require(
            _royaltyForRental <= 100 && _royaltyForRental >= 0,
            "Royalty for rental out of range"
        );
        require(
            _royaltyForOwnershipTransfer <= 100 &&
                _royaltyForOwnershipTransfer >= 0,
            "Royalty for Ownership Transfer out of range"
        );

        _royaltiesForRental[_tokenId] = _royaltyForRental;
        _royaltiesForOwnershipTransfer[_tokenId] = _royaltyForOwnershipTransfer;
    }

    function _royaltyForRental(uint256 _tokenId)
        internal
        view
        virtual
        returns (uint8)
    {
        require(!_exists(_tokenId), "ERC1190: token already minted");
        return _royaltiesForRental[_tokenId];
    }

    function _royaltyForOwnershipTransfer(uint256 _tokenId)
        internal
        view
        virtual
        returns (uint8)
    {
        require(!_exists(_tokenId), "ERC1190: token already minted");
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
        require(renter != address(0), "ERC1190: rent to the zero address");
        require(_exists(tokenId), "ERC1190: token not exists");

        _renters[tokenId][renter] = rentExpirationDateInMillis;
        _renterBalances[renter] += 1;

        emit AssetRented(renter, tokenId, rentExpirationDateInMillis);
    }

    /**
     * @dev See {IERC1190-getRented}.
     */
    function getRented(uint256 tokenId, address renter)
        public
        virtual
        override
        returns (uint256)
    {
        require(
            _exists(tokenId),
            "ERC1190: approved query for nonexistent token"
        );
        require(renter != address(0), "ERC1190: renter is the 0 address.");
        require(
            _renters[tokenId][renter] != 0,
            "The renter has not rented the token tokenId."
        );

        uint256 expiration = _renters[tokenId][renter];

        if (expiration < block.timestamp) {
            delete _renters[tokenId][renter];
            _renterBalances[renter] -= 1;
        }

        return _renters[tokenId][renter];
    }

    /**
     * @dev Internal function to invoke {IERC1190Receiver-onERC1190CreativeLicenseReceived} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC1190CreativeLicenseReceived(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC1190Receiver(to).onERC1190CreativeLicenseReceived(
                    _msgSender(),
                    from,
                    tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return
                    retval ==
                    IERC1190Receiver.onERC1190CreativeLicenseReceived.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC1190: transfer to non ERC1190Receiver implementer"
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
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC1190OwnershipLicenseReceived(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC1190Receiver(to).onERC1190OwnershipLicenseReceived(
                    _msgSender(),
                    from,
                    tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return
                    retval ==
                    IERC1190Receiver.onERC1190OwnershipLicenseReceived.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC1190: transfer to non ERC1190Receiver implementer"
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
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}
