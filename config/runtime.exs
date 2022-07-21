import Config

if config_env() == :dev do
  if not is_nil(System.get_env("USDC_HOLDER_PK")) do
    config :signet, :signer, default: {:priv_key, System.get_env("USDC_HOLDER_PK")}
  end

  if not is_nil(System.get_env("ETHEREUM_REMOTE_NODE")) do
    config :signet, :ethereum_node, System.get_env("ETHEREUM_REMOTE_NODE")
  end
end
