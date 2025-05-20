# app/lib/openai_client.rb
require "openai"

# NOTE: Nice job adding the OPENAI! However, you should have a configuration in your README, that say something like 'OPENAI API KEY needed' to run this locally 
class OpenaiClient
  def self.chat(messages, **opts)
    client.chat(
      parameters: {
        model: "gpt-4o-mini",
        temperature: 0.4,
        response_format: { type: "json_object" },
        store: true,                 # you had this in curl; optional
        messages: messages
      }.merge(opts)
    )
  end

  def self.client
    @client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
  end
end
