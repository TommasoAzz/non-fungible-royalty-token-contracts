# non-fungible-royalty-token-contracts
A university project for implementing a slightly modified version of the ERC1190 proposal "Non-Fungible Royalty Token".

Made for the course "Blockchain and Cryptocurrencies", University of Bologna, A.Y. 2021/2022.

This is part of the parent repository [non-fungible-royalty-token](https://github.com/TommasoAzz/non-fungible-royalty-token).
Here are implemented all the contracts that implement the slightly modified version of the ERC1190 proposal in an **OpenZeppelin** fashion.

## Structure of the repository
You may find:

- the contracts inside the `contracts` folder,
- the documentation of the contracts inside `docs`,
- some tests inside `test`.

## Prerequisites and steps to work with this contracts (or continue to develop them!)
### Requirements

- [Node.js](https://nodejs.org/en/) (compulsory),
- [Truffle](https://trufflesuite.com/tutorial/index.html#setting-up-the-development-environment) (compulsory),
- [Ganache](https://trufflesuite.com/ganache/) (advised, but not required).

### Initial setup

- `npm install`

If you want to use Ganache (as advised), please open it, press the button *Quickstart (Ethereum)* and, when loaded, click the *Settings* icon, visit the *Server* tab/page and ensure the port number under *Port number* is `8545` (otherwise the default configuration in `truffle-config.js` will not work).

If you do not want to use Ganache (not advised), please type the following command from within the project folder: `truffle develop`.
When it is loaded, please take note of the first row displayed. It should be "Truffle Develop started at http://127.0.0.1:.../".
Instead of the "..." you will find a port number, please check it is equal to that at line 11 of `truffle-config.js`. If it is not so, please update it.

### Other commands

- Compile the contracts: `npm run compile`
- Migrate the contracts (for testing purposes - some test contracts are deployed): `npm run migrate`
- Test the contracts: `npm run test`
- Generate **TypeScript** types: `npm run generate-types`
- Generate the documentation (based on **Solidity** comments): `npm run docs`
