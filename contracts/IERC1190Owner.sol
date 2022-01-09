// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERC1190Owner is IERC165 {
    event TransferOwnershipLicense(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Returns the number of owned (though an ownership license) tokens in ``owner``'s account.
     */
    function balanceOfOwner(address owner)
        external
        view
        returns (uint256 ownerBalance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

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
     * - If `to` refers to a smart contract, it must implement {IERC1190OwnershipLicenseReceiver-onERC1190OwnershipLicenseReceived}, which is called upon a safe transfer.
     *
     * Emits a {TransferOwnershipLicense} event.
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
     * - If `to` refers to a smart contract, it must implement {IERC1190OwnershipLicenseReceiver-onERC1190OwnershipLicenseReceived}, which is called upon a safe transfer.
     *
     * Emits a {TransferOwnershipLicense} event.
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
     * Emits a {TransferOwnershipLicense} event.
     */
    function transferOwnershipLicense(
        address from,
        address to,
        uint256 tokenId
    ) external;
}
