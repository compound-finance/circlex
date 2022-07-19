import Config

if config_env() == :test do
  config :circlex, :emulator,
    signer_mfa:
      (case(System.get_env("USDC_HOLDER_PK")) do
         "0x" <> priv_key ->
           {Signet.Signer.Curvy, :sign, [Base.decode16!(priv_key, case: :mixed)]}
       end)
end
