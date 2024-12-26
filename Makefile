include .env

verifyDiamond: 
	forge verify-contract \
    --chain-id 84532 \
	--rpc-url ${RPC_URL} \
    --num-of-optimizations 1000000 \
    --watch \
    --constructor-args $(user) $(diamond_cut) \
    --etherscan-api-key $(ETHERSCAN_API_KEY) \
    --compiler-version 0.8.0 \
    $(contract) contracts/Diamond.sol:Diamond


deployLocal:
	yarn hardhat run scripts/deploy.js --network anvil

deployApi:
	yarn hardhat run scripts/deployApi.js --network op

deployLive:
	yarn hardhat run scripts/deploy.js --network op

abigen:
	node scripts/generateDiamondABI.js

runDao:
	yarn hardhat run scripts/interractions/daoSettings.js --network op

approve:
	yarn hardhat run scripts/interractions/approve.js --network op

req:
	yarn hardhat run scripts/interractions/requestApi.js --network op

approveListing:
	yarn hardhat run scripts/interractions/approveListing.js --network anvil

getListings:
	yarn hardhat run scripts/interractions/getListings.js --network anvil