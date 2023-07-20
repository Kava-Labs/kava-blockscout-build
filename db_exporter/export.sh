#!/usr/bin/env bash

set -ex

# Use env var or default to "/export"
EXPORT_DIR="${EXPORT_DIR:-/export}"

# Create the export directory if it doesn't exist
mkdir -p "$EXPORT_DIR"

EXPORT_FILE="$EXPORT_DIR/smart_contracts_dump.sql"
EXPORT_FILE_UPDATED="$EXPORT_DIR/smart_contracts_import.sql"

echo "Exporting smart contracts to $EXPORT_FILE"
echo "Exporting smart contracts to $EXPORT_FILE_UPDATED"

pg_dump \
    -t public.smart_contracts \
    -t public.smart_contracts_additional_sources \
    -t public.contract_methods \
    -t public.addresses \
    -t public.tokens \
    "$DATABASE_URL" \
     > "$EXPORT_FILE"

# Make a copy to preserve original one for verification
cp "$EXPORT_FILE" "$EXPORT_FILE_UPDATED"

# Handle MacOS -i flag difference in sed
SEDOPTION="-i"
if [[ "$OSTYPE" == "darwin"* ]]; then
  SEDOPTION="-i ''"
fi

# Replace the table names with temporary new ones
sed $SEDOPTION 's/public.smart_contracts/imported.smart_contracts/g' "$EXPORT_FILE_UPDATED"
sed $SEDOPTION 's/public.contract_methods/imported.contract_methods/g' "$EXPORT_FILE_UPDATED"
sed $SEDOPTION 's/public.addresses/imported.addresses/g' "$EXPORT_FILE_UPDATED"
sed $SEDOPTION 's/public.tokens/imported.tokens/g' "$EXPORT_FILE_UPDATED"
