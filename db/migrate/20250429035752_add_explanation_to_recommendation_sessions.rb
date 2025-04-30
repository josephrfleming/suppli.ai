class AddExplanationToRecommendationSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :recommendation_sessions, :explanation, :text
  end
end
