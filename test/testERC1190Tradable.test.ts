import { ERC1190TradableInstance } from "../types/truffle-contracts";
import BN from "bn.js";
import { setTimeout } from 'timers/promises';

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

    let firstAccount: string;

    let secondAccount: string;

    let thirdAccount

    before(async () => {
        erc1190Tradable = await ERC1190TradableContract.deployed();
        firstAccount = accounts[0];
        secondAccount = accounts[1];
        thirdAccount = accounts[2];
    });

    it("Check name and symbol of token", async () => {
        assert.equal(await erc1190Tradable.name(), "ERC1190TradableTestToken");
        assert.equal(await erc1190Tradable.symbol(), "1190-TTST");
    });

    describe("Checking balance of owner before and after minting a new token", () => {
        let tokensOwned = (-1).toBN();
        let tokensCreativelyOwned = (-1).toBN();

        before(async () => {
            console.log("Before method call\t- tokensOwned = " + tokensOwned);
            console.log("\t\t\t- tokensCreativelyOwned = " + tokensCreativelyOwned);

            tokensOwned = await erc1190Tradable.balanceOfOwner(firstAccount);
            tokensCreativelyOwned = await erc1190Tradable.balanceOfCreativeOwner(firstAccount);

            console.log("After method call\t- tokensOwned = " + tokensOwned);
            console.log("\t\t\t- tokensCreativelyOwned = " + tokensCreativelyOwned);
        });

        it("Minting the contract and checking the balance", async () => {
            // Call performs a "fake transaction", i.e. performs the transaction, returns the result and then does a rollback.
            const tokenId = await erc1190Tradable.mint.call(firstAccount, "file", (1).toBN(), (1).toBN(), {
                from: firstAccount
            });
            console.log("Generated token's id - tokenId = " + tokenId.toString());
            await erc1190Tradable.mint.sendTransaction(firstAccount, "file", (1).toBN(), (1).toBN(), {
                from: firstAccount
            });

            tokensOwned = await erc1190Tradable.balanceOfOwner(firstAccount);
            tokensCreativelyOwned = await erc1190Tradable.balanceOfCreativeOwner(firstAccount);

            console.log("After mint call\t- tokensOwned = " + tokensOwned);
            console.log("\t\t- tokensCreativelyOwned = " + tokensCreativelyOwned);

            assert.equal(tokensOwned.toNumber(), 1);
            assert.equal(tokensCreativelyOwned.toNumber(), 1);

            const tokenURI = await erc1190Tradable.tokenURI(tokenId);
            assert.equal(tokenURI, "https://ipfs.io/ipfs/file");
            console.log("Token URI: " + tokenURI);
        });
    });

    describe("Checking balances after ownership transfer", () => {
        let tokensOwned = (-1).toBN();
        let tokensCreativelyOwned = (-1).toBN();

        before(async () => {
            console.log("Before method call\t- tokensOwned = " + tokensOwned);
            console.log("\t\t\t- tokensCreativelyOwned = " + tokensCreativelyOwned);

            tokensOwned = await erc1190Tradable.balanceOfOwner(firstAccount);
            tokensCreativelyOwned = await erc1190Tradable.balanceOfCreativeOwner(firstAccount);

            console.log("After method call\t- tokensOwned = " + tokensOwned);
            console.log("\t\t\t- tokensCreativelyOwned = " + tokensCreativelyOwned);
        });

        it("Approving secondaryAccount the transfer of the ownership license and then secondaryAccount pays the ownership license", async () => {
            await erc1190Tradable.setOwnershipLicensePrice((1).toBN(), (1000000).toBN(), {
                from: firstAccount
            });

            await erc1190Tradable.approve(secondAccount, (1).toBN(), {
                from: firstAccount
            });

            await erc1190Tradable.obtainOwnershipLicense.sendTransaction((1).toBN(), {
                from: secondAccount,
                value: (1000000).toBN()
            });

            const balanceOfAccount = await erc1190Tradable.balanceOfOwner(firstAccount);
            const balanceOfSecondaryAccount = await erc1190Tradable.balanceOfOwner(secondAccount);

            assert.equal(balanceOfAccount.toNumber(), 0);
            assert.equal(balanceOfSecondaryAccount.toNumber(), 1);
        });

        it("Transferring the creative license", async () => {
            await erc1190Tradable.methods["transferCreativeLicense(uint256,address)"].sendTransaction((1).toBN(), secondAccount, {
                from: firstAccount
            });

            const balanceOfAccount = await erc1190Tradable.balanceOfCreativeOwner(firstAccount);
            const balanceOfSecondaryAccount = await erc1190Tradable.balanceOfCreativeOwner(secondAccount);

            assert.equal(balanceOfAccount.toNumber(), 0);
            assert.equal(balanceOfSecondaryAccount.toNumber(), 1);
        });
    });

    describe("Renting an asset of a token", () => {
        let tokensRented = (-1).toBN();

        before(async () => {
            console.log("Before method call\t- tokensRented = " + tokensRented);

            tokensRented = await erc1190Tradable.balanceOfRenter(thirdAccount);

            console.log("After method call\t- tokensRented = " + tokensRented);
        });

        it("Renting asset", async () => {
            await erc1190Tradable.setRentalPrice((1).toBN(), 10, {
                from: firstAccount
            });

            const currentTimestamp = Date.now();
            const endOfRental = currentTimestamp + 5000; // 5 seconds later
            
            await erc1190Tradable.methods["rentAsset(uint256,uint256)"].sendTransaction((1).toBN(), endOfRental, {
                from: thirdAccount,
                value: (10 * 5).toBN()
            });

            const expirationDateStillValid = await erc1190Tradable.getRented.call((1).toBN(), thirdAccount);
            await erc1190Tradable.getRented.sendTransaction((1).toBN(), thirdAccount);

            const balanceOfRenter = await erc1190Tradable.balanceOfRenter(thirdAccount);

            const renters = await erc1190Tradable.rentersOf((1).toBN());

            assert.equal(balanceOfRenter.toNumber(), 1);
            assert.equal(renters.length, 1);
            assert.equal(renters[0], thirdAccount);
            assert.equal(expirationDateStillValid.toNumber(), endOfRental);

            const expirationDateInvalid = await (await setTimeout(5000, async () => {
                // Generating a random transaction just to update block.timestamp
                await erc1190Tradable.mint.sendTransaction(firstAccount, "file", (2).toBN(), (88).toBN());
                // Actual test
                const expirationDateInvalid = await erc1190Tradable.getRented.call((1).toBN(), thirdAccount);
                await erc1190Tradable.getRented.sendTransaction((1).toBN(), thirdAccount);

                
                return expirationDateInvalid;
            }))();

            console.log("EXPECTING 0 AND IT'S ACTUALLY " + expirationDateInvalid.toNumber());

            assert.equal(expirationDateInvalid.toNumber(), 0);
        });
    });
})