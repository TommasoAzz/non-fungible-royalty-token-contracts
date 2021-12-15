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
        address[] indexed creativeLicenseHolders,
        address[] indexed ownershipLicenseHolders,
        address[] indexed newOwners,
        uint256 indexed tokenId
    );

    event AssetRented(
        address[] indexed creativeLicenseHolders,
        address[] indexed ownershipLicenseHolders,
        address[] indexed renters,
        uint256 indexed tokenId
    );

    // Function to initialize token and set the owner(s) and the royalty rates. Returns the unique token ID for the digital asset.
    function approve(
        address[] owners,
        uint256 royaltyForOwnershipTransfer,
        uint256 royaltyForRental
    ) returns (uint256);

    // Function to transfer creative license of token
    function transferCreativeLicense(
        address[] creativeLicenseHolders,
        address[] newOwners,
        uint256 tokenId
    );

    // Function to transfer ownership license of token
    function transferOwnershipLicense(
        address[] creativeLicenseHolders,
        address[] ownershipLicenseHolders,
        address[] newOwners,
        uint256 tokenId
    );

    // Function to rent asset
    function rentAsset(
        address[] creativeLicenseHolders,
        address[] ownershipLicenseHolders,
        address[] renters,
        uint256 tokenId
    );
}
