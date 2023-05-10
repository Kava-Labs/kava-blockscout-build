# Kava Blocksout

This repostiory contains a docker build for a Kava branded and configured Blockscout used to power explorer.kava.io.

# Testing

```
npx hardhat node --hostname 0.0.0.0
docker-compose up
```

View localhost:4000

# Remove containers and dbdata volume
```
docker-compose down -v
```


