# app/helpers/research_helper.rb
module ResearchHelper
  # Build a PubMed search URL from supplement + goal
  def pubmed_search_url(supplement_name, goal)
    goals =
      case goal
      when Array
        goal
      when String
        str = goal.strip                       
        if str.start_with?("[") && str.end_with?("]")
          JSON.parse(str) rescue [str]        
        else
          [str]
        end
      else
        [goal.to_s]
      end

    clean_goal = goals.reject(&:blank?).join(" ")
    query       = "#{supplement_name} #{clean_goal}".strip

    "https://pubmed.ncbi.nlm.nih.gov/?term=#{CGI.escape(query)}"
  end
end
