package main

import (
	"fmt"
	"os"
	"strconv"

	"github.com/kava-labs/kava-blockscout-build/util/client"

	_ "github.com/joho/godotenv/autoload"
)

func usage(errMsg string) {
	fmt.Println("Usage: reindex_block <block-number>")
	if errMsg != "" {
		fmt.Printf("error: %s\n", errMsg)
	}
	os.Exit(1)
}

func main() {
	if len(os.Args) != 2 {
		usage("")
	}

	config := client.Config{
		RdsResourceArn: mustGetEnvVar("RDS_RESOURCE_ARN"),
		RdsSecretArn:   mustGetEnvVar("RDS_SECRET_ARN"),
		RdsDbName:      mustGetEnvVar("RDS_DB_NAME"),
		EvmJsonRpcUrl:  mustGetEnvVar("EVM_JSON_RPC_URL"),
	}

	// get height cli argument
	height, err := strconv.ParseInt(os.Args[1], 10, 64)
	if err != nil {
		usage(fmt.Sprintf("failed to parse <block-number> to int64: %s", os.Args[1]))
	}

	client, err := client.New(config)
	if err != nil {
		usage(fmt.Sprintf("failed to create client: %s", err))
	}

	// queue the block for indexing
	if err := client.QueueBlockReindex(height); err != nil {
		usage(fmt.Sprintf("failed to queue block block %d for reindex: %s", height, err))
	}

	// display current pending block operations
	fmt.Println()
	fmt.Println("current pending block operations:")
	ops, err := client.PendingBlockOperations()
	if err != nil {
		usage(err.Error())
	}
	for _, r := range ops {
		fmt.Printf("  %+v\n", r)
	}
}

func mustGetEnvVar(name string) string {
	value := os.Getenv(name)
	if value == "" {
		usage(fmt.Sprintf("no value set for %s", name))
	}
	return value
}
