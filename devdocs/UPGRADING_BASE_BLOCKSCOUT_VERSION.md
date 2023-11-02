# UPGRADING_BASE_BLOCKSCOUT_VERSION

## Building

Checkout a branch from the current version of this repo, then cd into the blockscout source code dir and checkout the tag you wish to update

```bash
cd $repo_dir
cd blockscout/blockscout-base/
git checkout v5.3.1-beta
```

Test custom kava patches locally will apply to avoid long dev cycles building production container

```bash
cd $repo_dir
cd blockscout/blockscout-base/
git apply ../patches/*.patch
```

if all patches apply with no error message, move on, else modify / delete / integrate patches with latest updated blockscout source code as needed

## Publishing Official Versions

Update values of `PRODUCTION_IMAGE_TAG`` and`BLOCKSCOUT_VERSION` in `.env` file

Open a PR

[Example PR](https://github.com/Kava-Labs/kava-blockscout-build/pull/19)

Once PR is approved, merge and new containers will be published

Deploy to production by updating [value for image tag](https://github.com/Kava-Labs/infrastructure/blob/master/terraform/product/production/us-east-1/blockscout-mainnet/service/terragrunt.hcl#L56) and running `terragrunt apply`

[Example Infra PR](https://github.com/Kava-Labs/infrastructure/pull/378)
