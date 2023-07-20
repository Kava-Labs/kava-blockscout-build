#!/bin/bash

# log all commands to stdout and stop the script on the first error
set -ex

DATA="/root/.kava/"

# exit early if geneis.json already exists
# which will happen if the kava docker container is stopped and later restarted
if test -f "/root/.kava/config/genesis.json" ; then
    echo "genesis.json alredy exists, skipping chain init and validator initilization"
else
    # create default genesis and node config
    kava init test --chain-id=localnet_7777-1

    # use the test backend to avoid prompts when storing and accessing keys
    kava config keyring-backend test

    # create an account for the delegator
    kava keys add kava-localnet-delegator

    # add the delegator account to the default genesis
    kava add-genesis-account $(kava keys show kava-localnet-delegator -a) 1000000000ukava

    # create genesis info for a validator staked by the delegator above
    kava gentx kava-localnet-delegator 500000000ukava \
        --chain-id=localnet_7777-1 \
        --moniker="kava-localnet-validator"

    # merge above transaction with previously generated default genesis
    kava collect-gentxs

    sed -in-place='' 's/stake/ukava/g' $DATA/config/genesis.json
    sed -in-place='' 's/aphoton/akava/g' $DATA/config/genesis.json
    sed -in-place='' 's/"max_gas": "-1"/"max_gas": "20000000"/' $DATA/config/genesis.json
fi

# set config for kava processes to use
cp /docker/kava/config.toml ~/.kava/config/config.toml

# start the kava process
kava start --trace --api.enable=true --rpc.laddr=tcp://0.0.0.0:26657 --json-rpc.address=0.0.0.0:8545

# run forever (kava start is non-blocking)
tail -f /dev/null
