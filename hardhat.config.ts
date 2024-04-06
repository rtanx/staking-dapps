import { HardhatUserConfig } from "hardhat/config";
import { config as dotenvconf } from "dotenv"
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";

dotenvconf();
const { ALCHEMY_API_URL, PRIVATE_KEY, ETHERSCAN_API_KEY, BSCSCAN_API_KEY, QUICKNODE_API_URL } = process.env
const { mnemonic } = require('./secrets.json');
const config: HardhatUserConfig = {
  solidity: "0.8.12",
  defaultNetwork: "goerli",
  networks: {
    hardhat: {},
    goerli: {
      url: ALCHEMY_API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    mainnet: {
      url: QUICKNODE_API_URL,
      chainId: 56,
      gasPrice: 20000000000,
      accounts: {
        mnemonic: mnemonic
      }
    }

  },
  etherscan: {
    apiKey: {
      goerli: `${ETHERSCAN_API_KEY}`,
      bsc: `${BSCSCAN_API_KEY}`
    }
  }
};

export default config;
