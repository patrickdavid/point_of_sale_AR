class Purchase < ActiveRecord::Base
  has_one :product
end
