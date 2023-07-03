#!/usr/bin/env bash

set -e

IMPORT_FILE_PATH=${IMPORT_FILE_PATH:-/import/smart_contracts_import.sql}
RUN_TESTS=${RUN_TESTS:-false}
KEEP_IMPORTED_SCHEMA=${KEEP_IMPORTED_SCHEMA:-false}
DRY_RUN=${DRY_RUN:-false}

# Check if DATABASE_URL is defined
if [ -z "$DATABASE_URL" ]; then
  echo "DATABASE_URL is not defined"
  exit 1
fi

# Parse DATABASE_URL parts, pg_prove doesn't support urls D:
export PGUSER=$(echo $DATABASE_URL | grep -oP "postgres://\K(.+?):" | cut -d: -f1)
export PGPASSWORD=$(echo $DATABASE_URL | grep -oP "postgres://.*:\K(.+?)@" | cut -d@ -f1)
export PGHOST=$(echo $DATABASE_URL | grep -oP "postgres://.*@\K(.+?):" | cut -d: -f1)
export PGPORT=$(echo $DATABASE_URL | grep -oP "postgres://.*@.*:\K(\d+)/" | cut -d/ -f1)
export PGDATABASE=$(echo $DATABASE_URL | grep -oP "postgres://.*@.*:.*/\K(.+?)$")

TRANSACTION_END="COMMIT;"
if [ "$DRY_RUN" = true ]; then
    TRANSACTION_END="ROLLBACK;"
fi

# If DRY_RUN and RUN_TESTS are both true, error
if [ "$DRY_RUN" = true ] && [ "$RUN_TESTS" = true ]; then
    echo "DRY_RUN and RUN_TESTS cannot both be true"
    exit 1
fi

# Check if file at IMPORT_FILE_PATH exists
if [ ! -f "$IMPORT_FILE_PATH" ]; then
    echo "Import SQL file at $IMPORT_FILE_PATH does not exist"
    exit 1
fi

# Runs all the SQL scripts in the specified order in a single transaction
psql "$DATABASE_URL" <<-EOSQL
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
    psql "$DATABASE_URL" -c "drop schema if exists imported cascade;"
else
    echo "Keeping imported schema"
fi
