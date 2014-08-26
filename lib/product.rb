class Product < ActiveRecord::Base
  has_many :purchases
  has_many :sales, through: :purchases
end
