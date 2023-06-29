#!/usr/bin/env bash

set -ex

pg_dump \
    -t public.smart_contracts \
    -t public.smart_contracts_additional_sources \
    -t public.contract_methods \
    -t public.addresses \
    "$DATABASE_URL" \
     > ./smart_contracts_dump.sql

# Make a copy to preserve original one for verification
cp smart_contracts_dump.sql smart_contracts_import.sql

# Replace the table names with temporary new ones
sed -i '' 's/public.smart_contracts/imported.smart_contracts/g' smart_contracts_import.sql
sed -i '' 's/public.contract_methods/imported.contract_methods/g' smart_contracts_import.sql
sed -i '' 's/public.addresses/imported.addresses/g' smart_contracts_import.sql

