import Config

config :circlex, :sns,
  http_client: HTTPoison,
  topic_arn: "arn:aws:sns:us-west-2:908968368384:sandbox_platform-notifications-topic"

config :circlex, :emulator,
  ethereum_node: "http://127.0.0.1:8545",
  usdc_address: "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
  chain_id: 5,
  merchant_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882"
