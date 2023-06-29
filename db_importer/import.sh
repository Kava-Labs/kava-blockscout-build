#!/usr/bin/env bash

set -ex

# Runs all the SQL scripts in the specified order in a single transaction
cat pre_import.sql smart_contracts_import.sql | psql "$DATABASE_URL" \
    --single-transaction

# Run pg_tap tests if RUN_TESTS=true
if [ "$RUN_TESTS" = true ]; then
    pg_prove -d "$DATABASE_URL" ./t
fi

cat post_import.sql | psql "$DATABASE_URL" \
    --single-transaction
