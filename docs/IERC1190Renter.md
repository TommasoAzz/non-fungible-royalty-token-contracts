## `IERC1190Renter`






### `balanceOfRenter(address renter) → uint256 renterBalance` (external)



Returns the number of tokens currently rented by ``renter``'s account.

### `rentersOf(uint256 tokenId) → address[] renters` (external)



Returns the renters of `tokenId`.

### `rentAsset(address renter, uint256 tokenId, uint256 rentExpirationDateInMillis)` (external)



Enables the renting of `tokenId` token to `renter`.

Requirements:

- `renter` cannot be the zero address.
- `tokenId` token must exist.

Emits a {AssetRented} event.

### `getRented(uint256 tokenId, address renter) → uint256 rentExpirationDateInMillis` (external)



Returns the expiration date in milliseconds if `renter` is renting `tokenId` token currently.
Calling this function twice could result in two diffent results if the `rentExpirationDateInMillis` corresponds to
an expired date time.

Requirements:

- `tokenId` must exist.
- `renter` must exist.
- `renter` must have rented `tokenId`.


### `AssetRented(address renter, uint256 tokenId, uint256 rentExpirationDateInMillis)`







