# frozen_string_literal: true

module ProductsHelper
  # Render a product’s tags as Bootstrap badges
  #
  # Example output:
  #   <span class="badge bg-secondary me-1">Vegan</span>
  #   <span class="badge bg-secondary me-1">Non-GMO</span>
  #
  def render_tags(product)
    return "" if product.tags.blank?

    safe_join(
      product.tags.map do |tag|
        content_tag(:span, tag.name, class: "badge bg-secondary me-1")
      end
    )
  end
end
