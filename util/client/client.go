package client

import (
	"context"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"math/big"
	"strings"

	"github.com/aws/aws-sdk-go-v2/aws"
	awsconfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/rdsdata"
	"github.com/aws/aws-sdk-go-v2/service/rdsdata/types"
	"github.com/ethereum/go-ethereum/ethclient"
)

// Config wraps the necessary parameters to create a Client
type Config struct {
	// ARN of the RDS cluster
	RdsResourceArn string
	// see https://docs.aws.amazon.com/secretsmanager/latest/userguide/create_database_secret.html
	RdsSecretArn string
	// name of the database inside the RDS cluster
	RdsDbName string
	// json-rpc api url for connecting to the evm, including port number
	EvmJsonRpcUrl string
}

// Client wraps functionality for interacting with a blockscout postgres database in AWS.
type Client struct {
	evm *ethclient.Client
	rds *rdsdata.Client

	rdsResourceArn string
	rdsSecretArn   string
	rdsDbName      string
}

// New creates a new client for interacting with a blockscout database in AWS.
func New(config Config) (*Client, error) {
	awsConfig, err := awsconfig.LoadDefaultConfig(context.Background())
	if err != nil {
		return nil, fmt.Errorf("loading aws config failed: %s", err)
	}

	evmClient, err := ethclient.Dial(config.EvmJsonRpcUrl)
	if err != nil {
		return nil, fmt.Errorf("failed to dial evm: %s", err)
	}

	return &Client{
		rdsResourceArn: config.RdsResourceArn,
		rdsSecretArn:   config.RdsSecretArn,
		rdsDbName:      config.RdsDbName,
		rds:            rdsdata.NewFromConfig(awsConfig),
		evm:            evmClient,
	}, nil
}

// executeStatement runs raw sql (with param inputs) on the blockscout database
func (c *Client) executeStatement(sql string, params []types.SqlParameter) (*rdsdata.ExecuteStatementOutput, error) {
	return c.rds.ExecuteStatement(context.Background(), &rdsdata.ExecuteStatementInput{
		ResourceArn:           aws.String(c.rdsResourceArn),
		SecretArn:             aws.String(c.rdsSecretArn),
		Sql:                   aws.String(sql),
		Database:              aws.String(c.rdsDbName),
		FormatRecordsAs:       "JSON",
		IncludeResultMetadata: true,
		Parameters:            params,
	})
}

// PendingBlockOperations represents a blocks currently in blockscout's index queue
// They are rows of the public.pending_block_operations table.
type PendingBlockOperations struct {
	BlockHash   string `json:"block_hash"` //base64 encoded
	InsertedAt  string `json:"inserted_at"`
	UpdatedAt   string `json:"updated_at"`
	BlockNumber int64  `json:"block_number"`
}

// PendingBlockOperations queries for all the currently pending block operations.
// These represent all the blocks currently in blockscout's index queue.
func (c *Client) PendingBlockOperations() ([]PendingBlockOperations, error) {
	var result []PendingBlockOperations
	res, err := c.executeStatement("SELECT * FROM public.pending_block_operations;", []types.SqlParameter{})
	if err != nil {
		return result, err
	}

	if err := json.Unmarshal([]byte(*res.FormattedRecords), &result); err != nil {
		return result, err
	}

	return result, nil
}

// QueueBlockReindex queries for the evm block hash by height & then injects a pending block operation
// for the block. Triggers blockscout to re-index the txs & internal txs in the block.
func (c *Client) QueueBlockReindex(height int64) error {
	// for some ungodly reason, ethclient doesn't expose the hash property from BlockByNumber...
	// it only exposes a Hash() calculation that doesn't result in the correct hash value.
	// get around that by making a direct call to the api and extracting the `hash`.
	var blockHashRes *struct {
		Hash string `json:"hash"`
	}

	// fetch the evm block hash for this height
	hexHeight := fmt.Sprintf("0x%s", hex.EncodeToString(big.NewInt(height).Bytes()))
	err := c.evm.Client().Call(&blockHashRes, "eth_getBlockByNumber", hexHeight, false)
	if err != nil {
		return err
	}

	fmt.Printf("block %d has hash %s\n", height, blockHashRes.Hash)
	// drop the 0x prefix
	blockHash := strings.Replace(blockHashRes.Hash, "0x", "", 1)

	// build sql to add new pending block operation
	statement := `
	INSERT into public.pending_block_operations (block_hash,inserted_at,updated_at,block_number)
	values (
			decode(:blockhash, 'hex'),
			now(),
			now(),
			:height
	);
	`
	params := []types.SqlParameter{
		{
			Name:  aws.String("blockhash"),
			Value: &types.FieldMemberStringValue{Value: blockHash},
		},
		{
			Name:  aws.String("height"),
			Value: &types.FieldMemberLongValue{Value: height},
		},
	}

	// execute statement
	_, err = c.executeStatement(statement, params)
	return err
}
