// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC1190.sol";

interface IERC1190Metadata is IERC1190 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
