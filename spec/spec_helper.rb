require 'active_record'
require 'rspec'
require 'shoulda-matchers'
require "purchase"
require 'product'
require 'sale'
require 'cashier'
require 'customer'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])


RSpec.configure do |config|
  config.after(:each) do
    Purchase.all.each { |purchase| purchase.destroy }
    Product.all.each { |product| product.destroy }
    Sale.all.each { |sale| sale.destroy }
    Cashier.all.each { |cashier| cashier.destroy }
    Customer.all.each { |customer| customer.destroy }
  end
end
