require 'active_record'
require 'rspec'
require 'shoulda-matchers'
require "purchase"
require 'product'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])


RSpec.configure do |config|
  config.after(:each) do
    # ????.all.each { |??| task.destroy }
  end
end
