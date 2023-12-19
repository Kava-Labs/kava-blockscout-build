defmodule KavaComsosApiClientTest do
  use ExUnit.Case
  doctest KavaComsosApiClient

  test "getTxByHash returns valid result for valid tx hash without 0x prefix" do
    client = %KavaComsosApiClient{}
    tx = KavaComsosApiClient.getTxByHash(client, "F3A411BA5C8C677DE7FD439BA6E3A9C18AF1339F4CD6833B1E917F6301C3CF18")
    assert tx.height == "7069479"
    assert tx.tx == "Co4DCtoCCh8vZXRoZXJtaW50LmV2bS52MS5Nc2dFdGhlcmV1bVR4ErYCCu8BChovZXRoZXJtaW50LmV2bS52MS5MZWdhY3lUeBLQAQioDRIKMTAwMDAwMDAwMBiQvwUiKjB4OTE5QzFjMjY3QkMwNmE3MDM5ZTAzZmNjMmVGNzM4NTI1NzY5MTA5YyoBMDJEqQWcuwAAAAAAAAAAAAAAAGvjOJ0Y/xlgS/cpcLZZqHKHc85pAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJpSQ6AhF/QiC96mqkTjWuJ3Gefw41GuKYHvPUs1aKRxb8i22/47BlyUogbAhc29XguEQtl6pnOUANbc/+Hk0OQEmF66/dxPHo/BUaQjB4MTYwMmNlMmFiYTkyZjA5ODI3YzZhMzQyMDIwOTA4MjQ5MDM2Y2I5ODYzZTY4OTUwNDEwOTVhZmRjZTM5MmE1Zfo/LgosL2V0aGVybWludC5ldm0udjEuRXh0ZW5zaW9uT3B0aW9uc0V0aGVyZXVtVHgSHxIdChcKBWFrYXZhEg45MDAwMDAwMDAwMDAwMBCQvwU="
  end

  test "getTxByHash returns valid result for valid tx hash with 0x prefix" do
    client = %KavaComsosApiClient{}
    tx = KavaComsosApiClient.getTxByHash(client, "0xF3A411BA5C8C677DE7FD439BA6E3A9C18AF1339F4CD6833B1E917F6301C3CF18")
    assert tx.height == "7069479"
    assert tx.tx == "Co4DCtoCCh8vZXRoZXJtaW50LmV2bS52MS5Nc2dFdGhlcmV1bVR4ErYCCu8BChovZXRoZXJtaW50LmV2bS52MS5MZWdhY3lUeBLQAQioDRIKMTAwMDAwMDAwMBiQvwUiKjB4OTE5QzFjMjY3QkMwNmE3MDM5ZTAzZmNjMmVGNzM4NTI1NzY5MTA5YyoBMDJEqQWcuwAAAAAAAAAAAAAAAGvjOJ0Y/xlgS/cpcLZZqHKHc85pAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJpSQ6AhF/QiC96mqkTjWuJ3Gefw41GuKYHvPUs1aKRxb8i22/47BlyUogbAhc29XguEQtl6pnOUANbc/+Hk0OQEmF66/dxPHo/BUaQjB4MTYwMmNlMmFiYTkyZjA5ODI3YzZhMzQyMDIwOTA4MjQ5MDM2Y2I5ODYzZTY4OTUwNDEwOTVhZmRjZTM5MmE1Zfo/LgosL2V0aGVybWludC5ldm0udjEuRXh0ZW5zaW9uT3B0aW9uc0V0aGVyZXVtVHgSHxIdChcKBWFrYXZhEg45MDAwMDAwMDAwMDAwMBCQvwU="
  end
end