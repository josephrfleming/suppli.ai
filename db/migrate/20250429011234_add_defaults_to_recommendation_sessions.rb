# db/migrate/20250429011234_add_defaults_to_recommendation_sessions.rb
class AddDefaultsToRecommendationSessions < ActiveRecord::Migration[7.1]
  def change
    execute <<~SQL
      ALTER TABLE recommendation_sessions
        ALTER COLUMN area_of_interest     SET DEFAULT '[]'::jsonb,
        ALTER COLUMN dietary_restrictions SET DEFAULT '[]'::jsonb,
        ALTER COLUMN result_json          SET DEFAULT '[]'::jsonb;
    SQL
  end
end
