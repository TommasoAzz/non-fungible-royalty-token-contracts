## `IERC1190Owner`






### `balanceOfOwner(address owner) → uint256 ownerBalance` (external)



Returns the number of owned (though an ownership license) tokens in ``owner``'s account.

### `ownerOf(uint256 tokenId) → address owner` (external)



Returns the owner of the `tokenId` token.

Requirements:

- `tokenId` must exist.

### `safeTransferOwnershipLicense(address from, address to, uint256 tokenId)` (external)



Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
are aware of the ERC-1190 protocol to prevent tokens from being forever locked.

Requirements:

- `from` cannot be the zero address.
- `to` cannot be the zero address.
- `tokenId` token must exist and be owned by `from`.
- If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
- If `to` refers to a smart contract, it must implement {IERC1190OwnershipLicenseReceiver-onERC1190OwnershipLicenseReceived}, which is called upon a safe transfer.

Emits a {TransferOwnershipLicense} event.

### `safeTransferOwnershipLicense(address from, address to, uint256 tokenId, bytes data)` (external)



Safely transfers `tokenId` token from `from` to `to`.

Requirements:

- `from` cannot be the zero address.
- `to` cannot be the zero address.
- `tokenId` token must exist and be owned by `from`.
- If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
- If `to` refers to a smart contract, it must implement {IERC1190OwnershipLicenseReceiver-onERC1190OwnershipLicenseReceived}, which is called upon a safe transfer.

Emits a {TransferOwnershipLicense} event.

### `transferOwnershipLicense(address from, address to, uint256 tokenId)` (external)



Transfers `tokenId` token from `from` to `to`.

WARNING: Usage of this method is discouraged, use {safeTransferOwnershipLicense} whenever possible.

Requirements:

- `from` cannot be the zero address.
- `to` cannot be the zero address.
- `tokenId` token must be owned by `from`.
- If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.

Emits a {TransferOwnershipLicense} event.


### `TransferOwnershipLicense(address from, address to, uint256 tokenId)`







