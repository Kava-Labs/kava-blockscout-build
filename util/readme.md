# what it is

This dir contains some go scripts for making life easier for misc blockscout maintenance.
Maybe someday the client will grow into a full blow reconciler that keeps the indexer honest...

> [!WARNING]
> This manipulates a real-live database. Proceed with caution.

# env

See [.env.example](.env.example) for an example. The code will yell at you if you have something wrong.

For Kava Labs users, see the shared password manager note for "Blockscout Util Env" for connecting to prod.

# reindex blocks

It fetches the block hash and injects the block into the to-be-processed queue for the indexer.
```
go run reindex_block.go <block-number>
```

Re-indexing a block will pick up any originally missed txs & internal txs (like missing creation info for smart contracts).
