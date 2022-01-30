## `ERC1190Tradable`



Implementation of ERC1190 with payable methods.


### `constructor(string tokenName, string tokenSymbol, string tokenBaseUri)` (public)



See {ERC1190-constructor}.

### `availableTokens() → uint256` (external)





### `ownershipPriceOf(uint256 tokenId) → uint256` (external)





### `creativeOwnershipPriceOf(uint256 tokenId) → uint256` (external)





### `rentalPriceOf(uint256 tokenId) → uint256` (external)





### `_baseURI() → string` (internal)

See {ERC1190-_baseURI}.



### `mint(address creator, string file, uint8 rentalRoyalty, uint8 ownershipTransferRoyalty) → uint256` (external)



Generates a new token and assigns its ownership and creative
license to `creator`.
The royalties are set via `rentalRoyalty` and `ownershipTransferRoyalty`.

### `setOwnershipLicensePrice(uint256 tokenId, uint256 priceInWei)` (external)



Sets the price for acquiring property of the ownership license of token
`tokenId`.

Requirements:

- `tokenId` must exist.
- `priceInWei` must be greater than 0.

### `setCreativeLicensePrice(uint256 tokenId, uint256 priceInWei)` (external)



Sets the price for acquiring property of the creative license of token
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

### `transferOwnershipLicense(uint256 tokenId, address to)` (external)



Transfers the ownership license from the current owner to the account `to`.

Requirements:

- `tokenId` must exist.
- the sender of the request must be the owner.
- the receiver account `to` must not be the zero address.

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

### `obtainCreativeLicense(uint256 tokenId)` (external)



Transfers the creative license from the current owner to the sender of the request.

Requirements:

- `tokenId` must exist.
- A creative license price must have been set via {setCreativeLicensePrice}.
- the sent money should be enough to cover the license expense.


### `TokenMinted(address creator, uint8 royaltyForRental, uint8 royaltyForOwnershipTransfer, uint256 tokenId)`







