# frozen_string_literal: true
class AiExplanationService
  MODEL = ENV.fetch("OPENAI_CHAT_MODEL", "gpt-4o-mini").freeze

 
  # Public entry
 
  def self.call(session)
    supplements = extract_supplements(session)
    return "No supplements to explain yet." if supplements.empty?

    prompt = build_prompt(session.budget, supplements)

    response = OpenaiClient.chat(
      parameters: {
        model: MODEL,
        messages: [
          { role: "system", content: "You are a helpful nutrition expert." },
          { role: "user",   content: prompt }
        ],
        temperature: 0.5,
        max_tokens:  400
      }
    )

    response.dig("choices", 0, "message", "content").presence ||
      "Sorry — no explanation was returned."
  rescue => e
    Rails.logger.warn "AI explanation error: #{e.class} – #{e.message}"
    "Sorry — there was a problem generating the explanation."
  end

  
  # private helpers
  
  class << self
    private

    def extract_supplements(session)
      json = session.result_json
      return json if json.is_a?(Array)
      json["supplements"] || []
    end

    def build_prompt(budget, supplements)
      bullets = supplements.map do |h|
        price = h["price_per_month"] || h["price"] || 0
        "• #{h['supplement_id']}: #{h['reason']} (≈ $#{price})"
      end.join("\n")

      <<~PROMPT
        Act as a PhD nutritionist. Explain, at a high level, why each item
        below was chosen and how the stack stays within a $#{budget} monthly
        budget. 150–200 words max.

        #{bullets}
      PROMPT
    end
  end
end
