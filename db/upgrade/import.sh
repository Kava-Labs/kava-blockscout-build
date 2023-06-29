#!/usr/bin/env bash

set -ex

# Runs all the SQL scripts in the specified order in a single transaction
cat pre_import.sql smart_contracts_import.sql post_import.sql | psql "$DATABASE_URL" \
    --single-transaction
