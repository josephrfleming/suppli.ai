# app/jobs/price_check_job.rb
class PriceCheckJob < ApplicationJob
  queue_as :default  # Sidekiq default queue

  def perform(product_id)
    product = Product.find_by(id: product_id)
    return unless product && product.active?  # skip if missing or inactive

    begin
      new_price = ExternalPricingService.fetch_price(product.sku)
    rescue StandardError => e
      Rails.logger.error "PriceCheckJob: failed to fetch price for Product #{product_id} - #{e.message}"
      raise  # let Sidekiq retry
    end

    if new_price.present? && new_price < product.price
      product.update(price: new_price)
      PriceAlertMailer.price_drop_alert(product.user, product, new_price).deliver_later
    end
  end
end
