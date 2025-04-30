# frozen_string_literal: true

class AiRecommender
  MODEL = ENV.fetch('OPENAI_CHAT_MODEL', 'gpt-4o').freeze

  SYSTEM_PROMPT = <<~TEXT
  You are a PhD nutritionist and supplement formulator.

  — You **must** keep the total monthly cost ≤ the USER_BUDGET (hard cap).
  — Return *pure JSON* (no markdown) shaped like:

    {
      "total_monthly_cost": 57.45,
      "supplements": [
        {
          "supplement_id":   "SP001",
          "name":            "Algae Omega-3",
          "price_per_month": 25.99,
          "retailer":        "iHerb",
          "daily_dosage":    "2 softgels (1 g EPA/DHA)",
          "reason":          "…"
        }
      ],
      "overview": "Short friendly paragraph (~150 words)…"
    }

  If the budget is too low for even one useful product, return an empty
  `supplements` array and set `"overview"` to a brief apology.
TEXT





  # setup
  
  def initialize(session)
    @session = session
  end


  # public API
  
  def recommend
    response = OpenaiClient.chat(
      build_messages,                    # ← 1st positional arg
      model:           MODEL,
      temperature:     0.4,
      response_format: { type: 'json_object' },
      max_tokens:      800
    )

    JSON.parse(response.dig('choices', 0, 'message', 'content'))
  rescue JSON::ParserError, StandardError => e
    Rails.logger.warn "AIRecommender error: #{e.class} – #{e.message}"
    fallback
  end

 
  # private helpers
 
  private

  def build_messages
    [
      { role: 'system', content: SYSTEM_PROMPT },
      { role: 'user',   content: user_prompt }
    ]
  end

  def user_prompt = <<~PROMPT
    USER_BUDGET:  $#{@session.budget}
  
    Areas of interest: #{Array(@session.area_of_interest).reject(&:blank?).join(', ').presence || 'none'}
    Dietary restrictions: #{Array(@session.dietary_restrictions).reject(&:blank?).join(', ').presence || 'none'}
  
    • Stay under the USER_BUDGET hard cap.
    • Prefer iHerb as the retailer for every item.
    • Follow the JSON schema exactly.
  PROMPT
  

  def fallback
    { 'supplements' => [], 'total_monthly_cost' => 0, 'overview' => '' }
  end
end
