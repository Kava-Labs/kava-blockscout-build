#!/usr/bin/env bash

# log all commands ran and exit script immediately
# on first non-zero return code from any command ran
set -ex

psql -v ON_ERROR_STOP=1 -U "$POSTGRES_ADMIN_USERNAME" <<-EOSQL
    ALTER SYSTEM SET max_connections = $POSTGRES_MAX_NUM_CONNECTIONS;

    CREATE USER $POSTGRES_BLOCKSCOUT_USERNAME;
    CREATE DATABASE $POSTGRES_BLOCKSCOUT_DATABASE_NAME ENCODING UTF8;

    GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_BLOCKSCOUT_DATABASE_NAME TO $POSTGRES_BLOCKSCOUT_USERNAME;

    ALTER USER $POSTGRES_BLOCKSCOUT_USERNAME WITH PASSWORD '$DB_BLOCKSCOUT_PASSWORD';

    \c $POSTGRES_BLOCKSCOUT_DATABASE_NAME

    GRANT ALL ON SCHEMA public TO $POSTGRES_BLOCKSCOUT_USERNAME;

    CREATE EXTENSION "pgtap";
    CREATE EXTENSION "pg_trgm";
    CREATE EXTENSION "btree_gist";
    CREATE EXTENSION "citext";

    \c postgres
EOSQL
