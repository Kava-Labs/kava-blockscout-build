#!/usr/bin/env bash

set -e

IMPORT_FILE_PATH=${IMPORT_FILE_PATH:-/import/smart_contracts_import.sql}
RUN_TESTS=${RUN_TESTS:-false}
KEEP_IMPORTED_SCHEMA=${KEEP_IMPORTED_SCHEMA:-false}
DRY_RUN=${DRY_RUN:-false}

TRANSACTION_END="COMMIT;"
if [ "$DRY_RUN" = true ]; then
    TRANSACTION_END="ROLLBACK;"
fi

# Check if file at IMPORT_FILE_PATH exists
if [ ! -f "$IMPORT_FILE_PATH" ]; then
    echo "Import SQL file at $IMPORT_FILE_PATH does not exist"
    exit 1
fi

# Runs all the SQL scripts in the specified order in a single transaction
psql <<-EOSQL
    \unset ECHO
    \set QUIET 1

    \pset format unaligned
    \pset tuples_only true
    \pset pager off

    \set ON_ERROR_ROLLBACK 1
    \set ON_ERROR_STOP true

    BEGIN;

    \echo 'Creating temporary schema'
    \i pre_import.sql

    \echo 'Importing smart contracts'
    \i $IMPORT_FILE_PATH

    \echo 'Post import'
    \i post_import.sql

    $TRANSACTION_END
EOSQL

# Run pg_prove tests if RUN_TESTS is true
if [ "$RUN_TESTS" = true ]; then
    echo "Running tests"
    pg_prove ./t/*.sql
else
    echo "Skipping tests"
fi

if [ "$KEEP_IMPORTED_SCHEMA" != true ]; then
    echo "Dropping temporary imported schema"

    # Run query to clear temporary schema. Run this separate from post_import.sql
    # So we can run the tests before clearing the schema.
    psql -c "drop schema if exists imported cascade;"
else
    echo "Keeping imported schema"
fi
