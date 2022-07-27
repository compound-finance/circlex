defmodule Circlex.Emulator.SNS do
  @moduledoc """
  Service to simulate sending SNS notifications.
  """

  require Logger

  defp sns_config(), do: Application.get_env(:circlex_api, :sns, [])
  def sns_http_client(), do: Keyword.get(sns_config(), :http_client)
  def sns_topic_arn(), do: Keyword.get(sns_config(), :topic_arn)

  defmodule Notification do
    defstruct [
      :type,
      :message_id,
      :topic_arn,
      :message,
      :timestamp,
      :signature_version,
      :signature,
      :signing_cert_url,
      :unsubscribe_url
    ]

    def serialize(%Notification{} = notification) do
      %{
        "Type" => notification.type,
        "MessageId" => notification.message_id,
        "TopicArn" => notification.topic_arn,
        "Message" => notification.message,
        "Timestamp" => DateTime.to_iso8601(notification.timestamp),
        "SignatureVersion" => notification.signature_version,
        "Signature" => notification.signature,
        "SigningCertURL" => notification.signing_cert_url,
        "UnsubscribeURL" => notification.unsubscribe_url
      }
    end

    def new(message) do
      %__MODULE__{
        type: "Notification",
        message_id: UUID.uuid1(),
        topic_arn: Circlex.Emulator.SNS.sns_topic_arn(),
        message: message,
        timestamp: DateTime.utc_now(),
        signature_version: "1",
        signature: "",
        signing_cert_url: "http://example.com",
        unsubscribe_url: "http://example.com"
      }
    end
  end

  def send_message(endpoint, notification = %Notification{}) do
    case sns_http_client() do
      nil ->
        Logger.warn("Not sending SNS message as no http client configured")

      http_client ->
        body =
          notification
          |> Notification.serialize()
          |> Jason.encode!()

        headers = [
          {"Content-Type", "text/plain"},
          {"x-amz-sns-message-type", notification.type}
        ]

        case http_client.post(endpoint, body, headers) do
          {:ok, %HTTPoison.Response{status_code: code}} when code in 200..299 ->
            :ok
        end
    end
  end
end
