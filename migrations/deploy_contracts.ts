type Network = "development" | "kovan" | "mainnet";

module.exports = (artifacts: Truffle.Artifacts) => {
  return async (
    deployer: Truffle.Deployer
  ) => {
    const ERC1190 = artifacts.require("ERC1190");
    const ERC1190Tradable = artifacts.require("ERC1190Tradable");

    await deployer.deploy(ERC1190);
    await deployer.deploy(ERC1190Tradable)
  };
};