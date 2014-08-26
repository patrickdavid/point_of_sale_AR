require 'active_record'
require './lib/purchase'
require './lib/product'
require './lib/sale'
require './lib/cashier'
require './lib/customer'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def welcome
  system 'clear'
  puts '*** Welcome to Point-of-Sale ***'
  puts 'Please choose from the following'
  puts '[M] << Manager'
  puts '[C] << Cashier'
  puts '[X] << Exit'
  case gets.chomp.upcase
  when 'M'
    manager_menu
  when 'C'
    cashier_menu
  when 'X'
    puts 'Thanks for playing!'
    exit
  else
    trippin
    welcome
  end
end


def trippin
  puts "You're trippin"
  sleep 2
end

welcome
