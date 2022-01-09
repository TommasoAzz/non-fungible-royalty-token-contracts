import { ERC1190TradableInstance } from "../types/truffle-contracts";
import BN from "bn.js";

const ERC1190TradableContract = artifacts.require("ERC1190Tradable");

export { }
declare global {
    export interface Number {
        toBN(): BN
    }
}

Number.prototype.toBN = function (this: number): BN {
    return new BN(this);
};

contract("ERC1190Tradable", (accounts) => {
    let erc1190Tradable: ERC1190TradableInstance;

    let account: string;

    before(async () => {
        erc1190Tradable = await ERC1190TradableContract.deployed();
        account = accounts[0];
    });

    it("Check name and symbol of token", async () => {
        assert.equal(await erc1190Tradable.name(), "ERC1190TradableTestToken");
        assert.equal(await erc1190Tradable.symbol(), "1190-TTST");
    });

    describe("Checking balance of owner before and after minting a new token", async () => {
        let tokensOwned = (-1).toBN();
        let tokensCreativelyOwned = (-1).toBN();

        before(async () => {
            console.log("Before method call\t- tokensOwned = " + tokensOwned);
            console.log("\t\t\t- tokensCreativelyOwned = " + tokensCreativelyOwned);

            tokensOwned = await erc1190Tradable.balanceOfOwner(account);
            tokensCreativelyOwned = await erc1190Tradable.balanceOfCreativeOwner(account);

            console.log("After method call\t- tokensOwned = " + tokensOwned);
            console.log("\t\t\t- tokensCreativelyOwned = " + tokensCreativelyOwned);
        });

        it("Minting the contract and checking the balance", async () => {
            // Call performs a "fake transaction", i.e. performs the transaction, returns the result and then does a rollback.
            const tokenId = await erc1190Tradable.mint.call(account, (1).toBN(), (1).toBN(), {
                from: account
            });
            console.log("Generated token's id - tokenId = " + tokenId.toString());
            await erc1190Tradable.mint.sendTransaction(account, (1).toBN(), (1).toBN(), {
                from: account
            });

            tokensOwned = await erc1190Tradable.balanceOfOwner(account);
            tokensCreativelyOwned = await erc1190Tradable.balanceOfCreativeOwner(account);
            
            console.log("After mint call\t- tokensOwned = " + tokensOwned);
            console.log("\t\t- tokensCreativelyOwned = " + tokensCreativelyOwned);
            
            assert.equal(tokensOwned.toNumber(), 1);
            assert.equal(tokensCreativelyOwned.toNumber(), 1);
        });
    });
})