require 'active_record'
require 'pry'
require './lib/purchase'
require './lib/product'
require './lib/sale'
require './lib/cashier'
require './lib/customer'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

@current_customer
@current_cashier
@current_sale = Sale.last
@current_product
@current_purchase

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
    sales_menu
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
  cashier_login
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
    reciept_menu
  when 'P'
    refund
  when 'M'
    welcome
  else
    trippin
    cashier_menu
  end
end

def sales_menu
  system 'clear'
  puts "Would you like to..."
  puts "[T] << View total sales"
  puts "[S] << Search for sales within a date range"
  puts "[M] << Return to the manager menu"
  case gets.chomp.upcase
  when "T"
    total_sales
  when "S"
    search_sales
  when "M"
    manager_menu
  else
    trippin
    sales_menu
  end
end

def total_sales
  total = 0
  puts "Here are the total sales:"
  Sale.all.each do |sale|
    sale.purchases.each do |purchase|
      total += (purchase.quantity.to_i * purchase.product.price)
    end
  end
  puts total
end

def search_sales
  puts "Please choose a customer from the following list:"
  Customer.all.each_with_index { |customer, index| puts "#{index + 1} #{customer.name}"}
  choice = gets.chomp.to_i - 1
  @current_customer = Customer.all[choice]
  Sale.all.each do |sale|
    sale.purchases.each do |purchase|
      total += (purchase.quantity.to_i * purchase.product.price)

  end
end

def add_product
  puts "Please enter Product name."
  name = gets.chomp
  puts "Please enter the price."
  price = gets.chomp.to_f
  Product.create({name: name, price: price})
  puts "New product added!"
  any_key
  manager_menu
end

def add_cashier
  puts "Please enter Cashier name."
  name = gets.chomp
  puts "Please enter the 4 digit login information"
  login = gets.chomp.to_i
  Cashier.create({name: name, login: login})
  puts "New cashier added!"
  any_key
  manager_menu
end

def add_customer
  puts "Please enter the Customer name"
  name = gets.chomp
  @current_customer = Customer.create({name: name})
  puts "New customer added!"
  any_key
end

def cashier_login
  puts "Please enter your cashier login"
  entry = gets.chomp.to_i
  @current_cashier = Cashier.find_by(login: entry)
  if @current_cashier != nil
    puts "Logged in as cashier: #{@current_cashier.name}"
    sleep 2
  else
    puts "login invalid!"
    cashier_login
  end
end

def create_sale
  puts "Is this a new customer? (Y/N)"
  reply = gets.chomp.upcase
  if reply == "Y"
    add_customer
  else
    puts "Please choose a customer from the following list:"
    Customer.all.each_with_index { |customer, index| puts "#{index + 1} #{customer.name}"}
    choice = gets.chomp.to_i - 1
    @current_customer = Customer.all[choice]
  end
  @current_sale = Sale.create(cashier_id: @current_cashier.id, customer_id: @current_customer.id)
  response = ''
  until response == 'N' do
    puts "Please choose a product number from the following list:"
    Product.all.each_with_index { |product, index| puts "#{index + 1} #{product.name} $#{product.price}" }
    choice = gets.chomp.to_i - 1
    @current_product = Product.all[choice]
    puts "Please enter the quantity of this product"
    quantity = gets.chomp.to_i
    new_purchase = Purchase.create({quantity: quantity, sale_id: @current_sale.id, product_id: @current_product.id})
    @current_sale.purchases << new_purchase
    current_reciept
    puts "Add another purchase? (Y/N)"
    response = gets.chomp.upcase
  end
  cashier_menu
end

def reciept_menu
  puts "Would you like to..."
  puts "[C] << See the current reciept"
  puts "[S] << Generate a reciept for a previous sale"
  puts "[M] << Return to the cashier menu"
  case gets.chomp.upcase
  when "C"
    current_reciept
    reciept_menu
  when "S"
    reciept_search
    reciept_menu
  when "M"
    cashier_menu
  else
    trippin
    reciept_menu
  end
end

def reciept_search
  puts "Please choose a customer from the following list:"
  Customer.all.each_with_index { |customer, index| puts "#{index + 1} #{customer.name}"}
  choice = gets.chomp.to_i - 1
  @current_customer = Customer.all[choice]
  puts "Please choose from the following sales for this customer by date: "
  @current_customer.sales.each_with_index do |sale, i|
    puts "#{i + 1} #{sale.created_at.strftime("%Y-%m-%d")}"
  end
  choice = gets.chomp.to_i - 1
  @current_sale = @current_customer.sales[choice]
  current_reciept
  any_key
  reciept_menu
end

def current_reciept
  puts "Here is your reciept:"
  @current_sale.purchases.each do |purchase|
    puts "#{purchase.product.name} x #{purchase.quantity} @ #{purchase.product.price} = #{purchase.quantity * purchase.product.price}"
  end
  puts "Your total is : #{total}"
end

def total
  total = 0
  @current_sale.purchases.each do |purchase|
    total += (purchase.quantity.to_i * purchase.product.price)
  end
  total
end


def trippin
  puts "You're trippin"
  sleep 2
end

def any_key
  puts "Press any key to continue"
  gets
end

welcome
