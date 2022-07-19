import Config

config :circlex, :sns,
  http_client: HTTPoison,
  topic_arn: "arn:aws:sns:us-west-2:908968368384:sandbox_platform-notifications-topic"
