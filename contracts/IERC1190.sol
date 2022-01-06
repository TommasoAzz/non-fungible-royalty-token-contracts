// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/**
 * @dev Required interface of an ERC1190 compliant contract.
 */
interface IERC1190 is IERC165 {
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool indexed approved
    );

    event TransferOwnershipLicense(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event TransferCreativeLicense(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event AssetRented(
        address indexed renter,
        uint256 indexed tokenId,
        uint256 rentExpirationDateInMillis
    );

    /**
     * @dev Returns the number of owned (though an ownership license) tokens in ``owner``'s account.
     */
    function balanceOfOwner(address owner)
        external
        view
        returns (uint256 ownerBalance);

    /**
     * @dev Returns the number of owned (through a creative license) tokens in ``creativeOwner``'s account.
     */
    function balanceOfCreativeOwner(address creativeOwner)
        external
        view
        returns (uint256 creativeOwnerBalance);

    /**
     * @dev Returns the number of tokens currently rented by ``renter``'s account.
     */
    function balanceOfRenter(address renter)
        external
        view
        returns (uint256 renterBalance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Returns the creative owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function creativeOwnerOf(uint256 tokenId)
        external
        view
        returns (address creativeOwner);

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferOwnershipLicense}, {safeTransferOwnershipLicense},
     * {transferCreativeLicense} or {safeTransferCreativeLicense} for any token
     * owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC-1190 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC1190Receiver-onERC1190Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC1190Receiver-onERC1190Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferOwnershipLicense} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC1190 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC1190Receiver-onERC1190Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferCreativeLicense(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC1190Receiver-onERC1190Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferCreativeLicense(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferCreativeLicense} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferCreativeLicense(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Enables the renting of `tokenId` token to `renter`.
     *
     * Requirements:
     *
     * - `renter` cannot be the zero address.
     * - `tokenId` token must exist.
     *
     * Emits a {AssetRented} event.
     */
    function rentAsset(
        address renter,
        uint256 tokenId,
        uint256 rentExpirationDateInMillis
    ) external;

    /**
     * @dev Returns the expiration date in milliseconds if `renter` is renting `tokenId` token currently.
     * Calling this function twice could result in two diffent results if the `rentExpirationDateInMillis` corresponds to
     * an expired date time.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     * - `renter` must exist.
     * - `renter` must have rented `tokenId`.
     */
    function getRented(uint256 tokenId, address renter)
        external
        returns (uint256 rentExpirationDateInMillis);
}
