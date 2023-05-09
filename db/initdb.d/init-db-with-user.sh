#!/usr/bin/env bash

set -e

psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" <<-EOSQL
    CREATE USER blockscout_user;
    CREATE DATABASE blockscout_testing ENCODING UTF8;

    GRANT ALL PRIVILEGES ON DATABASE blockscout_testing TO blockscout_user;

    ALTER USER blockscout_user WITH PASSWORD '$DB_BLOCKSCOUT_PASSWORD';

    \c blockscout_testing

    CREATE EXTENSION "pgtap";
    CREATE EXTENSION "pg_trgm";
    CREATE EXTENSION "btree_gist";
    CREATE EXTENSION "citext";

    \c postgres
EOSQL
