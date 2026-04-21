// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract RandomNumbers is VRFConsumerBaseV2Plus {
    uint256 s_subscriptionId;
    address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    bytes32 s_keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 callbackGasLimit = 2500000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 3; //how many numbers were returned
    uint256 count =1;
    uint256[] public s_randomNumber;
    address public Upkeep;

    mapping(uint256 => uint256[]) public s_rollDiceHistory;

    event RandomWordsFulfilled();

    constructor(uint256 subscriptionId) VRFConsumerBaseV2Plus(vrfCoordinator) {
        s_subscriptionId = subscriptionId;
    }

    function setUpkeep(address _Upkeep) external onlyOwner {
        Upkeep = _Upkeep;
    }

    function rollDiceAutomation() public {
        require(msg.sender == owner() || msg.sender == Upkeep, "Not authorized");
        rollDice();
    }

    function rollDice() internal returns (uint256 requestId) {
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
            })
        );
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        delete s_randomNumber;
        for (uint256 i = 0; i < randomWords.length; i++) {
            uint256 d30Value = (randomWords[i] % 30) + 1;
            s_randomNumber.push(d30Value);
            s_rollDiceHistory[count].push(d30Value);
        }
        count;
        emit RandomWordsFulfilled();
    }

    function getCount() public view returns (uint256) {
        return count;
    }

    function getRandomNumbers() public view returns (uint256[] memory) {
        return s_randomNumber;
    }

    function getRollDiceHistory(uint256 start, uint256 end) public view returns (uint256[][] memory) {
        require(end <= count, "out of range");
        require(start <= end, "invalid range");

        uint256[][] memory history = new uint256[][](end - start + 1);
        for (uint256 i = start; i <= end; i++) {
            history[i - start] = s_rollDiceHistory[i];
        }
        return history;
    }
}
