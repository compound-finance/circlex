import Config

if config_env() == :dev do
  if not is_nil(System.get_env("USDC_HOLDER_PK")) do
    config :signet, :signer, {:priv_key, System.get_env("USDC_HOLDER_PK")}
  end

  if not is_nil(System.get_env("ETHEREUM_REMOTE_NODE")) do
    config :circlex, :emulator, ethereum_remote_node: System.get_env("ETHEREUM_REMOTE_NODE")
  end
end
