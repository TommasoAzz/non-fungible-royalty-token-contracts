// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERC1190Approver is IERC165 {
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

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own ownership license of the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approveOwnership(address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the creative license of the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approveCreative(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved by owner for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApprovedOwnership(uint256 tokenId)
        external
        view
        returns (address operator);

    /**
     * @dev Returns the account approved by creative owner for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApprovedCreative(uint256 tokenId)
        external
        view
        returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {IERC1190Owner-transferOwnershipLicense},
     * {IERC1190Owner-safeTransferOwnershipLicense}, {IERC1190CreativeOwner-transferCreativeLicense}
     * or {IERC1190CreativeOwner-safeTransferCreativeLicense} for any token
     * owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalOwnershipForAll(address operator, bool approved)
        external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {IERC1190Owner-transferOwnershipLicense},
     * {IERC1190Owner-safeTransferOwnershipLicense}, {IERC1190CreativeOwner-transferCreativeLicense}
     * or {IERC1190CreativeOwner-safeTransferCreativeLicense} for any token
     * owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalCreativeForAll(address operator, bool approved)
        external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedOwnershipForAll(address owner, address operator)
        external
        view
        returns (bool);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `creator`.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedCreativeForAll(address owner, address operator)
        external
        view
        returns (bool);
}
