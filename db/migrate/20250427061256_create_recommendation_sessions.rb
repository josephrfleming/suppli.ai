class CreateRecommendationSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendation_sessions do |t|
      t.references :user,  null: true, foreign_key: true
      t.integer    :budget,              null: false
      t.text       :area_of_interest,    null: false
      t.text       :dietary_restrictions
      t.text       :notes
      t.jsonb      :result_json,         null: false, default: {}

      t.timestamps
    end
  end
end
