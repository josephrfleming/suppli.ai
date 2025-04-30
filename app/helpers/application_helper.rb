# frozen_string_literal: true

# Helpers shared across the app
module ApplicationHelper
  # Convert flash types to Bootstrap classes
  def bootstrap_class_for_flash(flash_type)
    case flash_type.to_sym
    when :notice then "success"
    when :alert, :error then "danger"
    else "info"
    end
  end
end
