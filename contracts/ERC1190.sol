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
 * @dev Implementation of IERC1190.sol, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC1190Enumerable}.
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
    mapping(uint256 => address) private _renters;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

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
     * @dev See {IERC1190-balanceOf}.
     */
    function balanceOf(address owner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            owner != address(0),
            "ERC1190: balance query for the zero address"
        );
        return _balances[owner];
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
     * @dev See {IERC1190-creatorOf}.
     */
    function creatorOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address creator = _creativeOwners[tokenId];
        require(
            creator != address(0),
            "ERC1190: creator query for nonexistent token"
        );
        return creator;
    }

    /**
     * @dev See {IERC1190Metadata-name}.pragma solidity ^0.8.0;

import "./IERC1190.sol";
import "./IERC1190Receiver.sol";
import "./extensions/IERC1190Metadata.sol";
import "../../utils/Address.sol";
import "../../utils/Context.sol";
import "../../utils/Strings.sol";
import "../../utils/introspection/ERC165.sol";

/**
 * @dev Implementation of IERC1190.sol, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC1190Enumerable}.
 */

    /**
     * @dev See {IERC1190Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC1190Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC1190Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
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
        address cretaor = ERC1190.creatorOf(tokenId);
        require(to != owner, "ERC1190: approval to current owner");
        require(to != cretor, "ERC1190: approval to current cretor");

        require(
            _msgSender() == owner ||
                _msgSender() == cretor ||
                isApprovedForAll(owner, _msgSender()),
            "ERC1190: approve caller is not owner nor crator nor approved for all"
        );

        _approve(to, tokenId);
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
     * @dev See {IERC1190-transferFrom}.
     */
    function transferOwnershipLicenceFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: transfer caller is not owner nor approved"
        );

        _transferOwnershipLicense(from, to, tokenId);
    }

    /**
     * @dev See {IERC1190-safeTransferFrom}.
     */
    function safeTransferOwnershipLicenceFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferOwnershipLicenceFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC1190-safeTransferFrom}.
     */
    function safeTransferOwnershipLicenceFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: transfer caller is not owner nor approved"
        );
        _safeTransferOwnershipLicence(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC1190 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC1190Receiver-onERC1190Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransferOwnershipLicence(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transferOwnershipLicense(from, to, tokenId);
        require(
            _checkOnERC1190Received(from, to, tokenId, _data),
            "ERC1190: transfer to non ERC1190Receiver implementer"
        );
    }

    /**
     * @dev See {IERC1190-transferFrom}.
     */
    function transferCreativeLicenceFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: transfer caller is not owner nor approved"
        );

        _transferCreativeLicence(from, to, tokenId);
    }

    /**
     * @dev See {IERC1190-safeTransferFrom}.
     */
    function safeCreativeLicenceTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeCreativeLicenceTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC1190-safeTransferFrom}.
     */
    function safeCreativeLicenceTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC1190: transfer caller is not owner nor approved"
        );
        _safeCreativeLicenceTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC1190 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC1190Receiver-onERC1190Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeCreativeLicenceTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transferCreativeLicence(from, to, tokenId);
        require(
            _checkOnERC1190Received(from, to, tokenId, _data),
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
        address creator = ERC1190.creatorOf(tokenId);
        return (spender == owner ||
            spender == creator ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
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
            _checkOnERC1190Received(address(0), to, tokenId, _data),
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

        _balances[to] += 1;
        _owners[tokenId] = to;
        _creativeOwners[tokenId] = to;

        emit TransferOwnershipLicence(address(0), to, tokenId);
        emit TransferCreativeLicence(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    // function _burn(uint256 tokenId) internal virtual {
    //     address owner = ERC1190.ownerOf(tokenId);
    //     address creator = ERC1190.creatorOf(tokenId);

    //     _beforeTokenTransfer(owner, address(0), tokenId);
    //     _beforeTokenTransfer(creator, address(0), tokenId);

    //     // Clear approvals
    //     _approve(address(0), tokenId);

    //     _balances[owner] -= 1;
    //     _balances[creator] -= 1;
    //     delete _creativeOwners[tokenId];
    //     delete _owners[tokenId];

    //     emit TransferOwnershipLicense(owner, address(0), tokenId);
    //     emit TransferCreativeLicence(creator, address(0), tokenId);
    // }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
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

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit TransferOwnershipLicense(from, to, tokenId);
    }

    function _transferCreativeLicense(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(
            ERC1190.creatorOf(tokenId) == from,
            "ERC1190: transfer of token that is not own"
        );
        require(to != address(0), "ERC1190: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _creativeOwners[tokenId] = to;

        emit TransferCreativeLicence(from, to, tokenId);
    }

    function _rentAssets(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(
            ERC1190.ownerOf(tokenId) == from,
            "ERC1190: transfer of token that is not own"
        );
        require(to != address(0), "ERC1190: transfer to the zero address");

        //_beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        //_approve(address(0), tokenId);

        //_balances[from] -= 1;
        //_balances[to] += 1;
        _renters[tokenId] = to;

        emit AssetRented(from, to, tokenId);
    }

    /**
     * @dev See {IERC1190-getApproved}.
     */
    function getRented(uint256 tokenId)
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

        return _renters[tokenId];
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
     * @dev Internal function to invoke {IERC1190Receiver-onERC1190Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC1190Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC1190Receiver(to).onERC1190Received(
                    _msgSender(),
                    from,
                    tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return retval == IERC1190Receiver.onERC1190Received.selector;
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
