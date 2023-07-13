#!/bin/bash
# fetches or computes data needed for forced contract verification
# using process defined in https://kava-labs.atlassian.net/wiki/spaces/ENG/pages/1290829828/Blockscout+Manual+Contract+Verification+Fixes

# log all commands and exit on first non-zero return code
set -ex

# parse command line flags
KAVA_EVM_RPC_ENDPOINT=$1
CONTRACT_OX_ADDRESS=$2

################ Step 1 ################
# fetch the byte code for the contract
response=$(curl "$KAVA_EVM_RPC_ENDPOINT" -X POST \
  -H "Content-Type: application/json" \
  --data @/dev/stdin<<EOF
    {
        "jsonrpc":"2.0",
        "method":"eth_getCode",
        "params":[
                "$CONTRACT_OX_ADDRESS",
                "latest"
        ],
        "id":1
    }
EOF
)

# parse code from response
code=$(echo $response | jq -r '.result')

# save code to file for use by other scripts
echo $code >> "$CONTRACT_OX_ADDRESS".bytecode

################ Step 2 ################

# compile smart contract with solidity

# Manually add \r\n for newlines to show up in UI, otherwise it will be all in 1 single line https://github.com/blockscout/blockscout/issues/1106
