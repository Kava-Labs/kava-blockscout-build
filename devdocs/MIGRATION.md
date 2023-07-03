# Contract Migration

These are two tools for exporting and importing verified smart contracts in a
PostgreSQL database for BlockScout.

### Building

```bash
make build-db-exporter
```

## Exporter

The exporter is a script that exports verified smart contracts from a PostgreSQL
database to a SQL file. The SQL file can then be imported into another database
using the importer.

Required environment variables:

- `DATABASE_URL`

Optional environment variable:

- `EXPORT_DIR` - Defaults to `/export`

### Usage

```bash
docker run \
    --env DATABASE_URL=postgres://blockscout_user:blockscout_password123@database_host:5444/blockscout_testing \
    -v ./db_exporter/export:/export \
    blockscout-db-exporter
```

The exporter will connect to the PostgreSQL database, export the verified smart
contracts and necessary additional data to the mounted export directory.

## Importer

The importer is a script that imports verified smart contracts from a SQL file
into a PostgreSQL database. The importer is designed to be used with BlockScout
to keep verified smart contracts when re-indexing the database.

Required environment variables:

- `DATABASE_URL`

Optional environment variables:

- `IMPORT_FILE_PATH` - The path to the previously exported SQL file. Ensure that
  your container mounts the correct file. Defaults to
  `/import/smart_contracts_import.sql`.
- `RUN_TESTS` - Whether to run tests after importing the SQL file. Defaults to
  `false`.
- `DRY_RUN` - Rolls back all changes if the import is successful. Defaults to
  `false`.
- `KEEP_IMPORTED_SCHEMA`: Whether to keep the temporary `imported` schema of the
  imported data. This is useful if you want to do additional testing to compare
  tables in the `imported` and `public` schemas. Defaults to `false`.

  **Note:** This will not work if `DRY_RUN` is set to `true`

### Usage

```bash
docker run \
    --net=host \
    --env DATABASE_URL=postgres://blockscout_user:blockscout_password123@database_host:5444/blockscout_testing \
    -e RUN_TESTS=true \
    -v ./db_exporter/export:/import \
    blockscout-db-importer
```
