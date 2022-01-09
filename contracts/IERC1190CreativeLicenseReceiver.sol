// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
 * @title ERC1190 creative license receiver interface.
 * @dev Interface for any contract that wants to support safe transfers
 * of creative licenses for ERC1190 contracts.
 */
interface IERC1190CreativeLicenseReceiver {
    /**
     * @dev Whenever a creative license for {IERC1190} `tokenId` token is transferred to this contract via {IERC1190CreativeOwner-safeTransferCreativeLicense}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC1190CreativeLicenseReceiver.onERC1190CreativeLicenseReceived.selector`.
     */
    function onERC1190CreativeLicenseReceived(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
