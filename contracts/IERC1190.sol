// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERC1190 is IERC165 {
    event Approval(
        address[] indexed _owner,
        address[] indexed _approved,
        uint256 indexed _tokenId
    );

    event CreativeLicenseTransferred(
        address[] indexed creativeLicenseHolders,
        address[] indexed newOwners,
        uint256 indexed tokenId
    );

    event OwnershipLicenseTransferred(
        address[] indexed ownershipLicenseHolders,
        address[] indexed newOwners,
        uint256 indexed tokenId
    );

    event AssetRented(
        address[] indexed ownershipLicenseHolders,
        address[] indexed renters,
        uint256 indexed tokenId
    );

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    // Function to initialize token and set the owner(s) and the royalty rates. Returns the unique token ID for the digital asset.
    function approve(
        address[] memory owners,
        uint256 royaltyForOwnershipTransfer,
        uint256 royaltyForRental
    ) external returns (uint256);

    // Function to transfer creative license of token
    function transferCreativeLicense(
        address[] memory creativeLicenseHolders,
        address[] memory newOwners,
        uint256 tokenId
    ) external;

    // Function to transfer ownership license of token
    function transferOwnershipLicense(
        address[] memory creativeLicenseHolders,
        address[] memory ownershipLicenseHolders,
        address[] memory newOwners,
        uint256 tokenId
    ) external;

    // Function to rent asset
    function rentAsset(
        address[] memory creativeLicenseHolders,
        address[] memory ownershipLicenseHolders,
        address[] memory renters,
        uint256 tokenId
    ) external;
}
