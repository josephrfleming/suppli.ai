# frozen_string_literal: true

# NOTE: Nice Job
class AiRecommender
  MODEL = ENV.fetch('OPENAI_CHAT_MODEL', 'gpt-4o').freeze

  SYSTEM_PROMPT = <<~TEXT
    You are a PhD nutritionist and supplement formulator.

    You must generate a personalized 30-day supplement stack based on:
    • The user's budget (hard cap).
    • Their medical conditions, medications, and current supplements.
    • Their goals (areas of interest) and dietary restrictions.

    Return *pure JSON* (no markdown) in this structure:

    {
      "total_monthly_cost": 284.50,
      "supplements": [
        {
          "supplement_id":   "SP001",
          "name":            "Algae Omega-3",
          "price_per_month": 25.99,
          "retailer":        "iHerb",
          "daily_dosage":    "2 softgels (1 g EPA/DHA)",
          "reason":          "Supports brain health, aligns with vegan diet"
        }
      ],
      "overview": "Short friendly paragraph (~150 words) explaining why this stack was chosen."
    }

    🧠 Recommendations must:
    • Be safe and relevant to the user's medical conditions.
    • Avoid any supplements the user is already taking.
    • Check for interactions with listed medications.
    • Respect dietary restrictions (e.g. vegan, vegetarian).

    💰 Budget rules:
    • Stay **under the USER_BUDGET**.
    • **Use as much of the budget as possible** — aim for 95%+ (e.g., $285 on a $300 budget).
    • If budget remains after core suggestions, add additional safe + relevant items.
    • You may recommend **as many as 20+ supplements** if they are distinct, helpful, and stay within budget.

    🚫 If budget is too low for even one useful item, return:
    {
      "total_monthly_cost": 0,
      "supplements": [],
      "overview": "Sorry, the budget is too low for a meaningful recommendation."
    }

    Your response must follow this exact JSON schema.
  TEXT

  def initialize(session)
    @session = session
  end

  def recommend
    response = OpenaiClient.chat(
      build_messages,
      model:           MODEL,
      temperature:     0.4,
      response_format: { type: 'json_object' },
      max_tokens:      2500
    )

    JSON.parse(response.dig('choices', 0, 'message', 'content'))
  rescue JSON::ParserError, StandardError => e
    Rails.logger.warn "AIRecommender error: #{e.class} – #{e.message}"
    fallback
  end

  private

  def build_messages
    [
      { role: 'system', content: SYSTEM_PROMPT },
      { role: 'user',   content: user_prompt }
    ]
  end

  def user_prompt = <<~PROMPT
    USER_BUDGET: $#{@session.budget}

    Medical conditions: #{@session.medical_conditions}
    Current medications: #{@session.current_medications}
    Current supplements: #{@session.current_supplements}

    Areas of interest: #{Array(@session.area_of_interest).reject(&:blank?).join(', ').presence || 'none'}
    Dietary restrictions: #{Array(@session.dietary_restrictions).reject(&:blank?).join(', ').presence || 'none'}

    Please:
    • Recommend a stack that is medically appropriate, with no conflicts.
    • Use as much of the budget as possible (≥ 95%) without going over.
    • Recommend as many supplements as needed (up to 20+ if helpful).
    • Do not include supplements the user is already taking.
    • Prefer iHerb as the retailer for every item.
    • Avoid any supplement that interacts with current medications.
    • Follow the JSON schema exactly.
  PROMPT

  def fallback
    {
      'supplements'         => [],
      'total_monthly_cost' => 0,
      'overview'            => ''
    }
  end
end
