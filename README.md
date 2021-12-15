
# Warp Core Boilerplate!

Welcome to our React/blockchain boiler plate application.

## Technology stack

This application uses Typescript, React, Hooks, and Hardhat.

Hook pattern - https://medium.com/@rossitrile93/how-i-replace-redux-redux-saga-with-react-446b4c84f788

## Project Setup

  

### Install dependencies

Warp Core uses Yarn [Workspaces](https://yarnpkg.com/features/workspaces), which means that to install all dependencies, all you need to do is make sure you're in the root directory and run:
```
yarn install
```
This should install everything for both the Hardhat envirnoment and React app. While this project was built using Yarn v2 (berry), it still uses the `node_modules` structure (`nodeLinker` is set to `node-modules` in `.yarnrc.yml`) due to some incompatbililities with Plug N Play with some of the dependencies. Warp Core currently utilizes one `node_modules` folder in the root directory where all dependencies are stored.

### WARNING!

Deploying to a local Hardhat chain should work out of the box, but in order to deploy to a network, you'll need to copy the `.example.env` file, rename it `.env`, and provide a private key for deployment along with an Infura api key.

Then uncomment the relevant snippet in `hardhat.config.ts`. The snippets look like the following:
```
ropsten: {
	url: https://rinkeby.infura.io/v3/${process.env.INFURA_PROJECT_ID},
	accounts: [0x${process.env.DEPLOYER_PRIVATE_KEY_ROPSTEN}],
},
```

Similarly, there is a `.example.env` in the `app/` directory with a number of global variables needed for the frontend. Copy it, rename it `.env` and fill in the relevant details. Not all may be needed in every case.

### Start project
#### Starting the chain and deploying
After successful installation of dependencies, run `yarn chain` to start the local dev chain.

After starting the chain locally and adding the deployer address you can deploy your contracts using `yarn deploy --network NETWORK` where `NETWORK` is replaced with the lowercase name of the network you wish to deploy to. (If no flag is given, the deploy will default to the local dev net.) To deploy to a network (other than the local dev net), uncomment the relevant snippet from `hardhat.config.ts` and ensure that you have added a private key and Infura API key to the `.env` file. Then run `yarn deploy` with the network flag, for example `yarn deploy --network rinkeby`. This can also be changed from inside the `hardhat.config.ts` file by changing the `defaultNetwork` parameter.

You can set conditional deployments based on the chain being deployed to. There are examples in `scripts/deploy.ts`.

#### Starting the frontend (app)

When you have done that, copy addresses that were given to you for your deployed contracts to the React `.env`. You can find an example `.env` under `/app/.example.env`. Copy the file, change its name to `.env` and add the relevant parameters.

To start the app, run:
```
yarn start
```
in the root or `app` directories to start the React app once the `.env` is set up in order to start the development server for the frontend.

### Project structure
The following is a diagram of Warp Core's structure:

```
|-app
	|- public/
	|- src/
		|- components/
		|- containers/
		|- interfaces/
		|- store/
			|- services/
			|- themeContext/
  
|-chain
	|- contracts/
	|- scripts/
	|- test/
	|- typings/
```
app folder: 
	public folder contains Title and icon for your application
	Under src folder is the logic: 
		directories:
			interfaces folder contains deployed contracts
			store folder contains services and theme context
				services folder contains all services

chain folder:
	contract folder contains written contracts for this chain.
	scripts folder contains file for deployment
	test folder contains files for each written contract and full coverage tests
	typings folder contains file for loading js modules such as dotenv


## Testing

Running `yarn run test-chain` will run the contract test suite.

Hardhat's testing framework is built on Waffle, which is built on Chai, which is built on Mocha. If you need to alter Mocha defaults, this can be done through the `mocha` object in `hardhat.config.ts`. A common example is the test timeout - Mocha defaults to 6 seconds, and tests can need longer. A commented out line appears in the `mocha` object for this. Uncommenting it will move the timeout to five minutes, which may be too long for your needs, so edit as you see fit.


## Future Improvements

This repo is a work in progress, and suggestions are welcome for how it can be improved. Some ideas are:

### General

* add subgraph functionality

### App

* create a boilerplate modal for buying and selling an ERC20 token
* create a boilerplate modal for auctioning an NFT
* bonding curve visualisations
* tests

### Chain

* provide OZ template contracts for an ERC20 and NFT
* provide a boilerplate for bonding curves
* provide better output on deploy
* improve `hardhat.config.ts` so that it doesn't it need commenting, uncommenting to switch networks
    * maybe a bogus private key and Infura API could be passed in
* full coverage on contract tests
