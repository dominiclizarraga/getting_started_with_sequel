require "bundler"
Bundler.require

require "yaml"

file_path = File.expand_path "../database.yaml", __FILE__
file = YAML.load_file file_path

db = Sequel.connect(file)

db.drop_table?(:products)

db.run "CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    price FLOAT,
    category VARCHAR(255)
  );"

db.drop_table?(:orders)

db.run "CREATE TABLE orders (
    id SERIAL PRIMARY KEY
  );"

db.drop_table?(:order_items)

db.run "CREATE TABLE order_items (
    id SERIAL PRIMARY KEY
  );"


db[:products].where(id: 1..2).order(:id)


db[:products].insert(name: "Apple", category: "Fruit", price: 12)

db[:products].insert(name: "Veal", category: "Meat", price: 31)

db[:products].insert(name: "Brocoli", category: "Vegetable", price: 98)

db[:products].insert(name: "Tomato", category: "Fruit", price: 154)

db[:products].insert(name: "Hammer", category: "Tool", price: 100)

db[:products].insert(name: "Screwdriver", category: "Tool", price: 6)

db[:products].insert(name: "Onion", category: "Vegetable", price: 77)

list = db[:products].all

class Product < Sequel::Model
  one_to_many :order_items
  many_to_many :orders, join_table: :order_items
    # attr_accessor :name, :category, :price
    # def initialize data
    #     @name = data[:name]
    #     @price = data[:price]
    #     @category = data[:category]
    # end
end


class Order < Sequel::Model
  one_to_many :order_items
  many_to_many :products, join_table: :order_items
end

class OrderItem < Sequel::Model
  many_to_one :order
  many_to_one :product
end

# p list.map { |item| Product.new item }

# p Product.all.count

# y = Product.new(name: "Yogurth", category: "Dessert", price: 36)

# y.save

# p Product.all.count

# p Product.order(:id).last[:name]

# y.destroy

# p Product.all.count

# p Product.order(:id).last[:name]

order = Order.new
order.save

products = Product.where(id: [2, 3]).all

products.each do |product|
  order.add_order_item product: product, quantity: 3
end

order.order_items.each do |item|
  puts "#{item.product.name} #{item.quantity}"
end