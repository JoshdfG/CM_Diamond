-include .env



# verifyDiamond: 
# 	forge verify-contract \
#     --chain-id 84532 \
# 	--rpc-url ${RPC_URL} \
#     --num-of-optimizations 1000000 \
#     --watch \
#     --constructor-args $(user) $(cut) $(address_zero) \
#     --etherscan-api-key $(ETHERSCAN_API_KEY) \
#     --compiler-version 0.8.0 \
#     $(contract) 
# 	contracts/Diamond.sol:Diamond

deploy:
	npx hardhat run scripts/deploy.js --network sepolia 

verifyOrganisationFactory:
	npx hardhat verify --network sepolia --contract contracts/facets/OrganisationFactoryFacet.sol:OrganisationFactoryFacet 0xad443B1F744887806c06cB7FC9C7c8D805d7e884

verifyDiamond:
	npx hardhat verify --network sepolia --contract contracts/Diamond.sol:Diamond --constructor-args arguments.js 0x7e879d1e400128f05C16BD569fC582cDe57F1459

	
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