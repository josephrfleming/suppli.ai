# app/helpers/retailers_helper.rb
module RetailersHelper
  # Always build an iHerb search URL for the supplement name
  def iherb_url(product_name)
    query = CGI.escape(product_name.to_s)
    "https://www.iherb.com/search?kw=#{query}"
  end
end
