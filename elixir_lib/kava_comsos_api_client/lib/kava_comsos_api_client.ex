defmodule KavaComsosApiClient do
  # enable logging
  require Logger

  # define main module struct with defaults
  defstruct [
    # which endpoint to use, defaults to mainnet archival endpoint
    endpoint_url: "https://rpc.data.kava.io",
    # how long to wait for the server to respond
    read_timeout_seconds: 5,
    # how many times to retry if the api returns a (potentially) retry-able error
    # such as a 5xx http error code
    max_retries: 3
  ]

  @moduledoc """
  `KavaComsosApiClient` provides a low level client for making a subset of
  requests to a Kava Network's Node Cosmos JSON-RPC API.
  """

  @doc """
  getTxByHash returns cosmos-sdk info for the specified tx (if it exists)

  ## Examples
      iex> client = %KavaComsosApiClient{}
      %KavaComsosApiClient{
        endpoint_url: "https://rpc.data.kava.io",
        read_timeout_seconds: 5,
        max_retries: 3
      }
      iex> KavaComsosApiClient.getTxByHash(client, "F3A411BA5C8C677DE7FD439BA6E3A9C18AF1339F4CD6833B1E917F6301C3CF18")

      %CosmosGetTxResponse{
        hash: "F3A411BA5C8C677DE7FD439BA6E3A9C18AF1339F4CD6833B1E917F6301C3CF18",
        height: "7069479",
        index: 36,
        tx_result: %TxResult{
          code: 11,
          data: nil,
          log: "out of gas in location: block gas meter; gasWanted: 90000, gasUsed: 61135: out of gas",
          info: "",
          gas_wanted: "90000",
          gas_used: "61135",
          events: [
            %{
              "attributes" => [
                %{
                  "index" => true,
                  "key" => "c3BlbmRlcg==",
                  "value" => "a2F2YTFsendoaDh5eGZhdmZoMDZuNHFzczJ5cmt5MmU0YTJqcTk2ZHpwOA=="
                },
                %{
                  "index" => true,
                  "key" => "YW1vdW50",
                  "value" => "OTB1a2F2YQ=="
                }
              ],
              "type" => "coin_spent"
            },
            %{
              "attributes" => [
                %{
                  "index" => true,
                  "key" => "cmVjZWl2ZXI=",
                  "value" => "a2F2YTE3eHBmdmFrbTJhbWc5NjJ5bHM2Zjg0ejNrZWxsOGM1bHZ2aGFhNg=="
                },
                %{
                  "index" => true,
                  "key" => "YW1vdW50",
                  "value" => "OTB1a2F2YQ=="
                }
              ],
              "type" => "coin_received"
            },
            %{
              "attributes" => [
                %{
                  "index" => true,
                  "key" => "cmVjaXBpZW50",
                  "value" => "a2F2YTE3eHBmdmFrbTJhbWc5NjJ5bHM2Zjg0ejNrZWxsOGM1bHZ2aGFhNg=="
                },
                %{
                  "index" => true,
                  "key" => "c2VuZGVy",
                  "value" => "a2F2YTFsendoaDh5eGZhdmZoMDZuNHFzczJ5cmt5MmU0YTJqcTk2ZHpwOA=="
                },
                %{
                  "index" => true,
                  "key" => "YW1vdW50",
                  "value" => "OTB1a2F2YQ=="
                }
              ],
              "type" => "transfer"
            },
            %{
              "attributes" => [
                %{
                  "index" => true,
                  "key" => "c2VuZGVy",
                  "value" => "a2F2YTFsendoaDh5eGZhdmZoMDZuNHFzczJ5cmt5MmU0YTJqcTk2ZHpwOA=="
                }
              ],
              "type" => "message"
            },
            %{
              "attributes" => [
                %{
                  "index" => true,
                  "key" => "ZmVl",
                  "value" => "OTAwMDAwMDAwMDAwMDBha2F2YQ=="
                }
              ],
              "type" => "tx"
            },
            %{
              "attributes" => [
                %{
                  "index" => true,
                  "key" => "ZXRoZXJldW1UeEhhc2g=",
                  "value" => "MHgxNjAyY2UyYWJhOTJmMDk4MjdjNmEzNDIwMjA5MDgyNDkwMzZjYjk4NjNlNjg5NTA0MTA5NWFmZGNlMzkyYTVl"
                },
                %{
                  "index" => true,
                  "key" => "dHhJbmRleA==",
                  "value" => "MzU="
                }
              ],
              "type" => "ethereum_tx"
            }
          ],
          codespace: "sdk"
        },
        tx: "Co4DCtoCCh8vZXRoZXJtaW50LmV2bS52MS5Nc2dFdGhlcmV1bVR4ErYCCu8BChovZXRoZXJtaW50LmV2bS52MS5MZWdhY3lUeBLQAQioDRIKMTAwMDAwMDAwMBiQvwUiKjB4OTE5QzFjMjY3QkMwNmE3MDM5ZTAzZmNjMmVGNzM4NTI1NzY5MTA5YyoBMDJEqQWcuwAAAAAAAAAAAAAAAGvjOJ0Y/xlgS/cpcLZZqHKHc85pAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJpSQ6AhF/QiC96mqkTjWuJ3Gefw41GuKYHvPUs1aKRxb8i22/47BlyUogbAhc29XguEQtl6pnOUANbc/+Hk0OQEmF66/dxPHo/BUaQjB4MTYwMmNlMmFiYTkyZjA5ODI3YzZhMzQyMDIwOTA4MjQ5MDM2Y2I5ODYzZTY4OTUwNDEwOTVhZmRjZTM5MmE1Zfo/LgosL2V0aGVybWludC5ldm0udjEuRXh0ZW5zaW9uT3B0aW9uc0V0aGVyZXVtVHgSHxIdChcKBWFrYXZhEg45MDAwMDAwMDAwMDAwMBCQvwU="
      }
  """
  def getTxByHash(%KavaComsosApiClient{}=client, hash) do
    # attempt to convert hash into full hex value if
    # not a hex string
    hash =
      case String.starts_with?(hash, "0x") do
        false ->
          "0x#{hash}"
        true ->
          hash
      end


    raw_response_result = Req.get!("#{client.endpoint_url}/tx?hash=#{hash}").body()["result"]
    raw_response_inner_tx_result =
      raw_response_result["tx_result"]

    %CosmosGetTxResponse{
      hash: raw_response_result["hash"],
      height: raw_response_result["height"],
      index: raw_response_result["index"],
      tx_result: %TxResult{
        code: raw_response_inner_tx_result["code"],
        data: raw_response_inner_tx_result["data"],
        log: raw_response_inner_tx_result["log"],
        info: raw_response_inner_tx_result["info"],
        gas_wanted: raw_response_inner_tx_result["gas_wanted"],
        gas_used: raw_response_inner_tx_result["gas_used"],
        events: raw_response_inner_tx_result["events"],
        codespace: raw_response_inner_tx_result["codespace"],
      },
      tx: raw_response_result["tx"]
    }
  end
end
