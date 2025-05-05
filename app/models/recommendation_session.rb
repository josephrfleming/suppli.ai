# app/models/recommendation_session.rb
class RecommendationSession < ApplicationRecord
  # Virtual fields (used in form, not stored directly)
  attr_accessor :medical_conditions, :current_medications, :current_supplements


  # Associations
  belongs_to :user, optional: true

 
  # Validations
  validates :budget, numericality: { greater_than: 0 }
  validates :area_of_interest, presence: true
end
