## `ERC1190Tradable`



Implementation of ERC1190 with payable methods.


### `constructor(string tokenName, string tokenSymbol)` (public)



See {ERC1190-constructor}.

### `mint(address creator, uint8 royaltyForRental, uint8 royaltyForOwnershipTransfer) → uint256` (external)



Generates a new token and assigns its ownership and creative
license to `creator`.
The royalties are set via `royaltyForRental` and `royaltyForOwnershipTransfer`.

### `setOwnershipLicensePrice(uint256 tokenId, uint256 priceInWei)` (external)



Sets the price for acquiring property of the ownership license of token
`tokenId`.

Requirements:

- `tokenId` must exist.
- `priceInWei` must be greater than 0.

### `setRentalPrice(uint256 tokenId, uint256 priceInWei)` (external)



Sets the price for renting `tokenId` for 1 second.

Requirements:

- `tokenId` must exist.
- `priceInWei` must be greater than 0.

### `rentAsset(uint256 tokenId, uint256 rentExpirationDateInMillis)` (external)



Rents the token `tokenId` for a total amount of `rentExpirationDateInMillis` ms.

Requirements:

- `tokenId` must exist.
- A rental price must have been set via {setRentalPrice}.
- `rentExpirationDateInMillis` should correspond to a future date.
- the sent money should be enough to cover the renting expenses.

### `obtainOwnershipLicense(uint256 tokenId)` (external)



Transfers the ownership license from the current owner to the sender of the request.

Requirements:

- `tokenId` must exist.
- A ownership license price must have been set via {setOwnershipLicensePrice}.
- the sent money should be enough to cover the license expense.

### `transferCreativeLicense(uint256 tokenId, address to)` (external)



Transfers the creative license from the current creative owner to the account `to`.

Requirements:

- `tokenId` must exist.
- the sender of the request must be the creative owner.
- the receiver account `to` must not be the zero address.




