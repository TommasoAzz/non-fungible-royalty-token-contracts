## `IERC1190CreativeOwner`






### `balanceOfCreativeOwner(address creativeOwner) → uint256 creativeOwnerBalance` (external)



Returns the number of owned (through a creative license) tokens in ``creativeOwner``'s account.

### `creativeOwnerOf(uint256 tokenId) → address creativeOwner` (external)



Returns the creative owner of the `tokenId` token.

Requirements:

- `tokenId` must exist.

### `safeTransferCreativeLicense(address from, address to, uint256 tokenId)` (external)



Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
are aware of the ERC1190 protocol to prevent tokens from being forever locked.

Requirements:

- `from` cannot be the zero address.
- `to` cannot be the zero address.
- `tokenId` token must exist and be owned by `from`.
- If the caller is not `from`, it must be have been allowed to move this token by either {IERC1190Approver-approveCreativeOwnership} or {IERC1190Approver-setApprovalCreativeOwnershipForAll}.
- If `to` refers to a smart contract, it must implement {IERC1190CreativeLicenseReceiver-onERC1190CreativeLicenseReceived}, which is called upon a safe transfer.

Emits a {TransferCreativeLicense} event.

### `safeTransferCreativeLicense(address from, address to, uint256 tokenId, bytes data)` (external)



Safely transfers `tokenId` token from `from` to `to`.

Requirements:

- `from` cannot be the zero address.
- `to` cannot be the zero address.
- `tokenId` token must exist and be owned by `from`.
- If the caller is not `from`, it must be have been allowed to move this token by either {IERC1190Approver-approveCreativeOwnership} or {IERC1190Approver-setApprovalCreativeOwnershipForAll}.
- If `to` refers to a smart contract, it must implement {IERC1190CreativeLicenseReceiver-onERC1190CreativeLicenseReceived}, which is called upon a safe transfer.

Emits a {TransferCreativeLicense} event.

### `transferCreativeLicense(address from, address to, uint256 tokenId)` (external)



Transfers `tokenId` token from `from` to `to`.

WARNING: Usage of this method is discouraged, use {safeTransferCreativeLicense} whenever possible.

Requirements:

- `from` cannot be the zero address.
- `to` cannot be the zero address.
- `tokenId` token must be owned by `from`.
- If the caller is not `from`, it must be have been allowed to move this token by either {IERC1190Approver-approveCreativeOwnership} or {IERC1190Approver-setApprovalCreativeOwnershipForAll}.

Emits a {TransferCreativeLicense} event.


### `TransferCreativeLicense(address from, address to, uint256 tokenId)`







