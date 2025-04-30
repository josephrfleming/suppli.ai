# app/helpers/research_helper.rb
module ResearchHelper
  # Returns a PubMed search URL for a given supplement and health goal
  def pubmed_search_url(supplement_name, goal)
    # Convert to array if it's a JSON string (defensive fix)
    goal_array =
      case goal
      when String
        goal.start_with?("[") ? JSON.parse(goal) : [goal]
      when Array
        goal
      else
        [goal.to_s]
      end
  
    clean_goal = goal_array.reject(&:blank?).join(" ")
    query = "#{supplement_name} #{clean_goal}".strip
  
    "https://pubmed.ncbi.nlm.nih.gov/?term=#{CGI.escape(query)}"
  rescue JSON::ParserError
    "https://pubmed.ncbi.nlm.nih.gov/?term=#{CGI.escape(supplement_name)}"
  end
  
  
end
