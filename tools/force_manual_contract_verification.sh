#!/bin/bash
# forces manual verification of a contract deployed on blockscout
# using process defined in https://kava-labs.atlassian.net/wiki/spaces/ENG/pages/1290829828/Blockscout+Manual+Contract+Verification+Fixes

# log all commands and exit on first non-zero return code
set -ex

# parse command line flags
stripped_0x_address=$1

################ Step 1 ################

# get the current addresses table values for the contract to force verify
read -r -d '' get_current_addresses_data_sql <<EOF
select *
  from public.addresses
where
  hash = decode('$stripped_0x_address', 'hex');
EOF

current_addresses_data=$(AWS_PROFILE=production aws rds-data execute-statement --secret-arn arn:aws:secretsmanager:us-east-1:830681326651:secret:blockscout-kava-10-creds-2-vHdYae --resource-arn arn:aws:rds:us-east-1:830681326651:cluster:blockscout-kava-10 --sql "$get_current_addresses_data_sql" --database blockscout_kava_10 | jq .records[0] )

echo $current_addresses_data

current_fetched_coin_balance=$(echo $current_addresses_data | jq .[0]."stringValue")
current_fetched_coin_balance_block_number=$(echo $current_addresses_data | jq .[1]."longValue")
current_hash=$(echo $current_addresses_data | jq .[2]."blobValue")
current_contract_code=$(echo $current_addresses_data | jq .[3]."stringValue")
current_inserted_at=$(echo $current_addresses_data | jq .[4]."stringValue")
current_updated_at=$(echo $current_addresses_data | jq .[5]."stringValue")
current_nonce=$(echo $current_addresses_data | jq .[6]."stringValue")
current_decompiled=$(echo $current_addresses_data | jq .[7]."booleanValue")
current_verified=$(echo $current_addresses_data | jq .[8]."booleanValue")
current_gas_used=$(echo $current_addresses_data | jq .[9]."stringValue")
current_transactions_count=$(echo $current_addresses_data | jq .[10]."longValue")
current_token_transfers_count=$(echo $current_addresses_data | jq .[11]."longValue")

echo $current_fetched_coin_balance $current_fetched_coin_balance_block_number $current_hash $current_contract_code $current_inserted_at $current_updated_at $current_nonce $current_decompiled $current_verified $current_gas_used $current_transactions_count $current_token_transfers_count

# read bytecode populated by prior execution of fetch_compute_contract_verification_data script
contract_byte_code=$(cat "0x$stripped_0x_address.bytecode")

echo $contract_byte_code

# upsert new values

################ Step 2 ################

# fetch current values from address_names table for contract
# upsert new values


# compute_contract_address_hash_sql="select * from decode('$stripped_0x_address', 'hex');"

# contract_address_hash=$(AWS_PROFILE=production aws rds-data execute-statement --secret-arn arn:aws:secretsmanager:us-east-1:830681326651:secret:blockscout-kava-10-creds-2-vHdYae --resource-arn arn:aws:rds:us-east-1:830681326651:cluster:blockscout-kava-10 --sql "$compute_contract_address_hash_sql" --database blockscout_kava_10 | jq .records[0][0].blobValue)

# echo $contract_address_hash

################ Step 3 ################

# fetch current values from smart_contracts table for contract
# upsert new values

# read -r -d '' sql <<EOF
# insert into
#     public.smart_contracts (
#         name,
#         compiler_version,
#         optimization,
#         contract_source_code,
#         abi,
#         address_hash,
#         inserted_at,
#         updated_at,
#         constructor_arguments,
#         optimization_runs,
#         evm_version,
#         verified_via_sourcify,
#         is_vyper_contract,
#         partially_verified,
#         file_path,
#         is_changed_bytecode
#     )
# values
#     (
#         'ATOM',
#         'v0.8.18+commit.87f61d96',
#         true,
#         '// Sources flattened with hardhat v2.14.0 https://hardhat.org
# \r\n// SPDX-License-Identifier: MIT
# \r\n
# \r\n// File @openzeppelin/contracts/utils/Context.sol@v4.8.3
# \r\n
# \r\n// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
# \r\n
# \r\npragma solidity ^0.8.0;
# \r\n
# \r\n/**
# \r\n * @dev Provides information about the current execution context, including the
# \r\n * sender of the transaction and its data. While these are generally available
# \r\n * via msg.sender and msg.data, they should not be accessed in such a direct
# \r\n * manner, since when dealing with meta-transactions the account sending and
# \r\n * paying for execution may not be the actual sender (as far as an application
# \r\n * is concerned).
# \r\n *
# \r\n * This contract is only required for intermediate, library-like contracts.
# \r\n */
# \r\nabstract contract Context {
# \r\n}',
#         '[{"inputs":[{"internalType":"string","name":"name","type":"string"},{"internalType":"string","name":"symbol","type":"string"},{"internalType":"uint8","name":"decimals_","type":"uint8"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burn","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
#         decode ('15932e26f5bd4923d46a2b205191c4b5d5f43fe3', 'hex'),
#         now (),
#         now (),
#         NULL,
#         1000,
#         'default',
#         NULL,
#         false,
#         NULL,
#         NULL,
#         true
#     );
# EOF


################ Step 4 ################

# fetch current values from tokens table for contract
# upsert new values
