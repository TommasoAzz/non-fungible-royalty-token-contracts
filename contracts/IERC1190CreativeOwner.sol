// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERC1190CreativeOwner is IERC165 {
    event TransferCreativeLicense(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Returns the number of owned (through a creative license) tokens in ``creativeOwner``'s account.
     */
    function balanceOfCreativeOwner(address creativeOwner)
        external
        view
        returns (uint256 creativeOwnerBalance);

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
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC1190 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {IERC1190Approver-approveCreativeOwnership} or {IERC1190Approver-setApprovalCreativeOwnershipForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC1190CreativeLicenseReceiver-onERC1190CreativeLicenseReceived}, which is called upon a safe transfer.
     *
     * Emits a {TransferCreativeLicense} event.
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
     * - If the caller is not `from`, it must be have been allowed to move this token by either {IERC1190Approver-approveCreativeOwnership} or {IERC1190Approver-setApprovalCreativeOwnershipForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC1190CreativeLicenseReceiver-onERC1190CreativeLicenseReceived}, which is called upon a safe transfer.
     *
     * Emits a {TransferCreativeLicense} event.
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
     * - If the caller is not `from`, it must be have been allowed to move this token by either {IERC1190Approver-approveCreativeOwnership} or {IERC1190Approver-setApprovalCreativeOwnershipForAll}.
     *
     * Emits a {TransferCreativeLicense} event.
     */
    function transferCreativeLicense(
        address from,
        address to,
        uint256 tokenId
    ) external;
}
