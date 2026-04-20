-include .env
deploy:;forge script script/Deploy.s.sol --broadcast  --rpc-url $(SEPOLIA_RPC_URL) --verify --etherscan-api-key $(ETHERSCAN_API_KEY) --account deployer
setUpkeep:;cast send $(CONTRACT_ADDRESS) "setUpkeep(address)" $(UPKEEPADDRESS)  --rpc-url $(SEPOLIA_RPC_URL) --account deployer
send:;cast send $(CONTRACT_ADDRESS) "rollDiceAutomation()"  --rpc-url $(SEPOLIA_RPC_URL) --account deployer
call:;cast call $(CONTRACT_ADDRESS) "getRandomNumbers()(uint256[])"  --rpc-url $(SEPOLIA_RPC_URL) --account deployer
history:;cast call $(CONTRACT_ADDRESS) "getRollDiceHistory(uint256,uint256)(uint256[][])" $(START) $(END) --rpc-url $(SEPOLIA_RPC_URL) --account deployer