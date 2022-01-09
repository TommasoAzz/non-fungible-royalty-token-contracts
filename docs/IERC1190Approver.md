## `IERC1190Approver`






### `approve(address to, uint256 tokenId)` (external)



Gives permission to `to` to transfer `tokenId` token to another account.
The approval is cleared when the token is transferred.

Only a single account can be approved at a time, so approving the zero address clears previous approvals.

Requirements:

- The caller must own the token or be an approved operator.
- `tokenId` must exist.

Emits an {Approval} event.

### `getApproved(uint256 tokenId) → address operator` (external)



Returns the account approved for `tokenId` token.

Requirements:

- `tokenId` must exist.

### `setApprovalForAll(address operator, bool approved)` (external)



Approve or remove `operator` as an operator for the caller.
Operators can call {IERC1190Owner-transferOwnershipLicense}, 
{IERC1190Owner-safeTransferOwnershipLicense}, {IERC1190CreativeOwner-transferCreativeLicense} 
or {IERC1190CreativeOwner-safeTransferCreativeLicense} for any token
owned by the caller.

Requirements:

- The `operator` cannot be the caller.

Emits an {ApprovalForAll} event.

### `isApprovedForAll(address owner, address operator) → bool` (external)



Returns if the `operator` is allowed to manage all of the assets of `owner`.

See {setApprovalForAll}.


### `Approval(address owner, address approved, uint256 tokenId)`





### `ApprovalForAll(address owner, address operator, bool approved)`







