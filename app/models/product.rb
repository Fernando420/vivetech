class Product < ApplicationRecord
  belongs_to :orders, optional: true
  belongs_to :user
  has_many :variants
end