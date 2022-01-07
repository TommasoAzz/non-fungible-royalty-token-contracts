import { ERC1190TradableInstance } from "../types/truffle-contracts";

const ERC1190TradableContract = artifacts.require("ERC1190Tradable");

contract("ERC1190Tradable", (accounts) => {
    let erc1190: ERC1190TradableInstance;

    before(async () => {
        erc1190 = await ERC1190TradableContract.deployed();
    });
})