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

def manager_menu
  system 'clear'
  puts 'Please choose from the following'
  puts '[P] << Add new product'
  puts '[C] << Add new cashier'
  puts '[S] << View sales information'
  puts '[I] << View product information'
  puts '[M] << Return to main menu'
  case gets.chomp.upcase
  when 'P'
    add_product
  when 'C'
    add_cashier
  when 'S'
    view_sales
  when 'I'
    product_info
  when 'M'
    welcome
  else
    trippin
    manager_menu
  end
end

def cashier_menu
  system 'clear'
  puts 'Please choose from the following'
  puts '[N] << Create new sale'
  puts '[R] << Generate reciept'
  puts '[P] << Process refund'
  puts '[M] << Return to main menu'
  case gets.chomp.upcase
  when 'N'
    create_sale
  when 'R'
    reciept
  when 'P'
    refund
  when 'M'
    welcome
  else
    trippin
    cashier_menu
  end
end

def add_product
  puts "Please enter Product name."
  name = gets.chomp
  puts "Please enter the price."
  price = gets.chomp.to_f
  new_product = Product.create({name: name, price: price})
  puts "Your product has been added"
  puts "Press any key to continue."
  gets
  manager_menu
end


welcome
