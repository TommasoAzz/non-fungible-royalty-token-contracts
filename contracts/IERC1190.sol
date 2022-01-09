// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC1190Owner.sol";
import "./IERC1190CreativeOwner.sol";
import "./IERC1190Renter.sol";
import "./IERC1190Approver.sol";

/**
 * @dev Required interface of an ERC1190 compliant contract.
 */
interface IERC1190 is
    IERC1190Approver,
    IERC1190Owner,
    IERC1190CreativeOwner,
    IERC1190Renter
{

}
