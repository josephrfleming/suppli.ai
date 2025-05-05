# app/jobs/recommend_job.rb
class RecommendJob
  include Sidekiq::Worker

  def perform(session_id)
    session = RecommendationSession.find_by(id: session_id)
    return if session.nil?  # skip if not found

    # mock AI results 
    ai_results_array = [
      { supplement_id: 12, price: 29.99, retailer: "Amazon",
        reason: "Clinically proven for sleep" },
      { supplement_id: 7,  price: 18.50, retailer: "iHerb",
        reason: "High-dose Omega-3 for heart" }
    ]

    session.update!(result_json: ai_results_array)
  end
end
