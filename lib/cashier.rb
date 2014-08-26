class Cashier < ActiveRecord::Base
  has_many :sales
  has_and_belongs_to_many :customers
end
