type Network = "development" | "kovan" | "mainnet";

module.exports = (artifacts: Truffle.Artifacts) => {
  return async (
    deployer: Truffle.Deployer
  ) => {
    const ERC1190 = artifacts.require("ERC1190");
    const ERC1190Tradable = artifacts.require("ERC1190Tradable");

    // Deploying test contracts!
    deployer.deploy(ERC1190, "ERC1190TradableTestToken", "1190-TTST");
    deployer.deploy(ERC1190Tradable, "ERC1190TradableTestToken", "1190-TTST", "https://ipfs.io/ipfs/");
  };
};
