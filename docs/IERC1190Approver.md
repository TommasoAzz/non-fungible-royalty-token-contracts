## `IERC1190Approver`






### `approveOwnership(address to, uint256 tokenId)` (external)



Gives permission to `to` to transfer `tokenId`'s ownership license to another account.
The approval is cleared when the token is transferred.

Only a single account can be approved at a time, so approving the zero address clears previous approvals.

Requirements:

- The caller must own ownership license of the token or be an approved operator.
- `tokenId` must exist.

Emits an {Approval} event.

### `approveCreativeOwnership(address to, uint256 tokenId)` (external)



Gives permission to `to` to transfer `tokenId`'s creative ownership to another account.
The approval is cleared when the token is transferred.

Only a single account can be approved at a time, so approving the zero address clears previous approvals.

Requirements:

- The caller must own the creative license of the token or be an approved operator.
- `tokenId` must exist.

Emits an {Approval} event.

### `getApprovedOwnership(uint256 tokenId) → address operator` (external)



Returns the account approved by owner for `tokenId` token.

Requirements:

- `tokenId` must exist.

### `getApprovedCreativeOwnership(uint256 tokenId) → address operator` (external)



Returns the account approved by creative owner for `tokenId` token.

Requirements:

- `tokenId` must exist.

### `setApprovalOwnershipForAll(address operator, bool approved)` (external)



Approve or remove `operator` as an operator for the caller.
Operators can call {IERC1190Owner-transferOwnershipLicense},
{IERC1190Owner-safeTransferOwnershipLicense} for any token
owned by the caller.

Requirements:

- The `operator` cannot be the caller.

Emits an {ApprovalForAll} event.

### `setApprovalCreativeOwnershipForAll(address operator, bool approved)` (external)



Approve or remove `operator` as an operator for the caller.
Operators can call {IERC1190CreativeOwner-transferCreativeLicense}
or {IERC1190CreativeOwner-safeTransferCreativeLicense} for any token
creative owned by the caller.

Requirements:

- The `operator` cannot be the caller.

Emits an {ApprovalForAll} event.

### `isApprovedOwnershipForAll(address owner, address operator) → bool` (external)



Returns if the `operator` is allowed to manage all of the assets of `owner`.

See {setApprovalForAll}.

### `isApprovedCreativeOwnershipForAll(address owner, address operator) → bool` (external)



Returns if the `operator` is allowed to manage all of the assets of `creative owner`.

See {setApprovalForAll}.


### `Approval(address owner, address approved, uint256 tokenId)`





### `ApprovalForAll(address owner, address operator, bool approved)`







