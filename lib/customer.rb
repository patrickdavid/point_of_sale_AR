class Customer < ActiveRecord::Base
  has_many :sales
  has_and_belongs_to_many :cashiers
end
