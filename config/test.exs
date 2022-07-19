import Config

# Default assumptions here are a fork of Goerli
config :circlex, :emulator,
  ethereum_node: "http://127.0.0.1:8545",
  usdc_address: "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
  chain_id: 5

config :circlex, :sns,
  http_client: MockHTTPoison,
  topic_arn: "arn:aws:sns:us-west-2:908968368384:sandbox_platform-notifications-topic"
