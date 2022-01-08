type Network = "development" | "kovan" | "mainnet";

module.exports = (artifacts: Truffle.Artifacts) => {
  return async (
    deployer: Truffle.Deployer
  ) => {
    // const IERC165 = artifacts.require("IERC165");
    const ERC165 = artifacts.require("ERC165");

    // const IERC1190 = artifacts.require("IERC1190");
    // const IERC1190Metadata = artifacts.require("IERC1190Metadata");
    // const IERC1190Receiver = artifacts.require("IERC1190Receiver");

    const ERC1190 = artifacts.require("ERC1190");
    const ERC1190Tradable = artifacts.require("ERC1190Tradable");

    // Deploying interfaces
    // deployer.deploy(IERC165);
    // deployer.deploy(ERC165);

    // deployer.deploy(IERC1190);
    // deployer.deploy(IERC1190Metadata);
    // deployer.deploy(IERC1190Receiver);

    // Deploying test contracts!
    deployer.deploy(ERC1190, "ERC1190TradableTestToken", "1190-TTST");
    deployer.deploy(ERC1190Tradable, "ERC1190TradableTestToken", "1190-TTST", "");
  };
};
