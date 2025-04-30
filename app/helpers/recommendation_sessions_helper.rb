# frozen_string_literal: true

require "uri"

module RecommendationSessionsHelper
  # Return a search URL for a given retailer and supplement
  def retailer_url(retailer, supplement_name)
    case retailer.to_s.downcase
    when "iherb"
      "https://www.iherb.com/search?kw=#{URI.encode_www_form_component(supplement_name)}"
    else
      nil # no link for unsupported retailers
    end
  end
end
