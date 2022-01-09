// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IERC1190Renter is IERC165 {
    event AssetRented(
        address indexed renter,
        uint256 indexed tokenId,
        uint256 rentExpirationDateInMillis
    );

    /**
     * @dev Returns the number of tokens currently rented by ``renter``'s account.
     */
    function balanceOfRenter(address renter)
        external
        view
        returns (uint256 renterBalance);

    /**
     * @dev Returns the renters of `tokenId`.
     */
    function rentersOf(uint256 tokenId)
        external
        view
        returns (address[] memory renters);

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
