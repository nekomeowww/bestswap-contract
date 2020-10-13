// SPDX-License-Identifier: None

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./NFT.sol";

contract NFTHoldingEnumerator {
    struct HoldingInfo {
        uint256 tokenId;
        uint256 quality;
        address approved;
    }

    function getHoldingsOf(NFT nft, address account) external view returns (HoldingInfo[] memory result) {
        uint256 count = nft.balanceOf(account);
        result = new HoldingInfo[](count);

        for (uint256 i = 0; i < count; i++) {
            result[i].tokenId = nft.tokenOfOwnerByIndex(account, i);
            result[i].quality = nft.qualityOf(result[i].tokenId);
            result[i].approved = nft.getApproved(result[i].tokenId);
        }
    }
}
