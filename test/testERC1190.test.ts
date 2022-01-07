import { ERC1190Instance } from "../types/truffle-contracts";

const ERC1190Contract = artifacts.require("ERC1190");

contract("ERC1190", (accounts) => {
    let erc1190: ERC1190Instance;

    before(async () => {
        erc1190 = await ERC1190Contract.deployed();
    });
})