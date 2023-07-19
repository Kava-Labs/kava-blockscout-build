-- Copies imported data to the public schema, handling conflicts
-- Copy addresses to public schema
insert into
  public.addresses
select
  *
from
  imported.addresses on conflict (hash) do
update
set
  contract_code = excluded.contract_code,
  updated_at = excluded.updated_at,
  verified = excluded.verified;

-- Copy contract addresses. EXCLUDES id column so that it is auto-incremented correctly.
-- v4.1.1 columns
insert into
  public.smart_contracts (
    name,
    compiler_version,
    optimization,
    contract_source_code,
    abi,
    address_hash,
    inserted_at,
    updated_at,
    constructor_arguments,
    optimization_runs,
    evm_version,
    external_libraries,
    verified_via_sourcify,
    is_vyper_contract,
    partially_verified,
    file_path,
    is_changed_bytecode,
    bytecode_checked_at,
    contract_code_md5,
    implementation_name,
    implementation_address_hash,
    implementation_fetched_at,
    compiler_settings
  )
select
  name,
  compiler_version,
  optimization,
  contract_source_code,
  abi,
  address_hash,
  inserted_at,
  updated_at,
  constructor_arguments,
  optimization_runs,
  evm_version,
  external_libraries,
  verified_via_sourcify,
  is_vyper_contract,
  partially_verified,
  file_path,
  is_changed_bytecode,
  bytecode_checked_at,
  -- new columns not in previous version (v4.1.1)
  -- Follows the default values in the migrations.
  md5 (contract_source_code),
  null, -- implementation_name
  null, -- implementation_address_hash
  null, -- implementation_fetched_at
  null -- compiler_settings
from
  imported.smart_contracts on conflict (address_hash) do nothing;

-- Copy additional sources
-- The only constraint is the serial ID column, so there could be duplicate
-- rows with the same file_name for a single address_hash
insert into
  public.smart_contracts_additional_sources (
    file_name,
    contract_source_code,
    address_hash,
    inserted_at,
    updated_at
  )
select
  file_name,
  contract_source_code,
  address_hash,
  inserted_at,
  updated_at
from
  imported.smart_contracts_additional_sources;

-- Update addresses table with contract name, update name column if row already exists
-- * Reuse the name from smart_contracts for address_names.
-- * Update the existing name if address already exists.
-- * Exclude id serial column
insert into
  public.address_names (
    address_hash,
    name,
    "primary",
    inserted_at,
    updated_at
  )
select
  address_hash,
  name,
  true, -- Set this as primary address
  inserted_at,
  updated_at
from
  imported.smart_contracts on conflict (address_hash, name) do
update
set
  name = excluded.name,
  updated_at = excluded.updated_at;

-- Add tokens
insert into
  public.tokens (
    name,
    symbol,
    total_supply,
    decimals,
    type,
    cataloged,
    contract_address_hash,
    inserted_at,
    updated_at,
    -- Null-able columns below, fine if they are missing
    holder_count,
    skip_metadata,
    fiat_value,
    circulating_market_cap,
    total_supply_updated_at_block,
    icon_url
  )
select
  name,
  symbol,
  total_supply,
  decimals,
  type,
  cataloged,
  contract_address_hash,
  inserted_at,
  updated_at,
  holder_count,
  skip_metadata,
  fiat_value,
  circulating_market_cap,
  total_supply_updated_at_block,
  icon_url
from
  imported.tokens on conflict (contract_address_hash) do
update
set
  name = excluded.name,
  symbol = excluded.symbol,
  total_supply = excluded.total_supply,
  decimals = excluded.decimals,
  type = excluded.type,
  cataloged = excluded.cataloged,
  updated_at = excluded.updated_at,
  holder_count = excluded.holder_count,
  skip_metadata = excluded.skip_metadata,
  fiat_value = excluded.fiat_value,
  circulating_market_cap = excluded.circulating_market_cap,
  total_supply_updated_at_block = excluded.total_supply_updated_at_block,
  icon_url = excluded.icon_url;