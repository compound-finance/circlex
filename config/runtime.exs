import Config

if config_env() == :test || not is_nil(System.get_env("USDC_HOLDER_PK")) do
  config :circlex, :emulator,
    signer_mfa:
      (case(System.get_env("USDC_HOLDER_PK")) do
         "0x" <> priv_key ->
           {Signet.Signer.Curvy, :sign, [Base.decode16!(priv_key, case: :mixed)]}
       end)
end

if config_env() == :dev || not is_nil(System.get_env("ETHEREUM_REMOTE_NODE")) do
  config :circlex, :emulator,
    ethereum_remote_node: System.get_env("ETHEREUM_REMOTE_NODE")
end
