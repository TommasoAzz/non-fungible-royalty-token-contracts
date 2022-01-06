// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
 * @title ERC1190 token receiver interface.
 * @dev Interface for any contract that wants to support safe transfers
 * from ERC1190 asset contracts.
 */
interface IERC1190Receiver {
    /**
     * @dev Whenever a ownership license for {IERC1190} `tokenId` token is transferred to this contract via {IERC1190-safeTransfer}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC1190.onERC1190Received.selector`.
     */
    function onERC1190OwnershipLicenseReceived(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @dev Whenever a creative license for {IERC1190} `tokenId` token is transferred to this contract via {IERC1190-safeTransfer}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC1190.onERC1190Received.selector`.
     */
    function onERC1190CreativeLicenseReceived(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
