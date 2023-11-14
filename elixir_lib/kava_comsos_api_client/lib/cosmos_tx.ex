defmodule CosmosGetTxResponse do
  defstruct [
    :hash,
    :height,
    :index,
    :tx_result,
    :tx
  ]
end

defmodule TxResult do
  defstruct [
    :code,
    :data,
    :log,
    :info,
    :gas_wanted,
    :gas_used,
    :events,
    :codespace
  ]
end
