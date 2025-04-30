# app/models/recommendation_session.rb
class RecommendationSession < ApplicationRecord
  
  # Associations

  belongs_to :user, optional: true

  
  # Validations
 
  validates :budget, numericality: { greater_than: 0 }
  validates :area_of_interest, presence: true
end
