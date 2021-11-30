class Product < ApplicationRecord
  belongs_to :user
  has_many :variants
  enum status: [:processing,:process]



end