-- start transaction and plan the tests.
begin;

select
    plan (9);

-- run the tests.
select
    has_schema ('imported', 'imported schema should be created');

select
    has_table (
        'imported',
        'addresses',
        'addresses table should be created'
    );

select
    has_table (
        'imported',
        'smart_contracts',
        'smart_contracts table should be created'
    );

select
    has_table (
        'imported',
        'smart_contracts_additional_sources',
        'smart_contracts_additional_sources table should be created'
    );

select
    has_table (
        'imported',
        'contract_methods',
        'contract_methods table should be created'
    );

select
    bag_eq (
        'select hash, contract_code from imported.addresses',
        'select hash, contract_code from public.addresses where hash in (select hash from imported.addresses)',
        'addresses should be imported with the new bytecode'
    );

select
    bag_eq (
        'select address_hash, contract_source_code from imported.smart_contracts',
        'select address_hash, contract_source_code from public.smart_contracts where address_hash in (select address_hash from imported.smart_contracts)',
        'smart_contracts should be imported with their contract_source_code'
    );

select
    bag_eq (
        'select name from imported.smart_contracts',
        'select name from public.address_names where address_hash in (select address_hash from imported.smart_contracts)',
        'address_names should be imported and updated from the imported.smart_contracts table'
    );

select
    set_hasnt (
        'select "primary" from public.address_names where address_hash in (select address_hash from imported.smart_contracts)',
        'select false',
        'imported addresses should be primary name'
    );

-- finish the tests and clean up.
select
    *
from
    finish ();

rollback;