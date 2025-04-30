# app/models/product.rb  (continuing from above)
class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many   :product_tags, dependent: :destroy
  has_many   :tags, through: :product_tags

  # Validations
  validates :name,  presence: true, 
                    uniqueness: { scope: :user_id, case_sensitive: false } 
  validates :price, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [true, false] }
  # Example format validation (if SKU code consists of alphanumeric only):
  validates :sku, format: { with: /\A[A-Z0-9]+\z/, message: "only allows letters and numbers" }, allow_nil: true

  # Scope definitions...
  scope :active, -> { where(active: true) }
  scope :recent, -> { order(created_at: :desc) }
end

# app/models/category.rb
class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end

# app/models/tag.rb
class Tag < ApplicationRecord
  has_many :product_tags, dependent: :destroy
  has_many :products, through: :product_tags

  validates :name, presence: true, uniqueness: true
end
