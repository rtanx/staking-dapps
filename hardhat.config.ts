import { HardhatUserConfig } from "hardhat/config";
import { config as dotenvconf } from "dotenv"
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";

dotenvconf();
const { ALCHEMY_API_URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env

const config: HardhatUserConfig = {
  solidity: "0.8.12",
  defaultNetwork: "goerli",
  networks: {
    hardhat: {},
    goerli: {
      url: ALCHEMY_API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
  },
  etherscan: {
    apiKey: {
      goerli: `${ETHERSCAN_API_KEY}`
    }
  }
};

export default config;
