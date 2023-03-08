require "bundler"
Bundler.require

require "yaml"

file_path = File.expand_path "../database.yaml", __FILE__
file = YAML.load_file file_path

db = Sequel.connect(file)

db.drop_table?(:products, cascade: true)

db.run "CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    price FLOAT,
    category VARCHAR(255)
  );"

db.drop_table?(:orders, cascade: true)

db.run "CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_name VARCHAR(255)
  );"

db.drop_table?(:order_details, cascade: true)

db.run "CREATE TABLE order_details (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER
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
  one_to_many :order_details
  many_to_many :orders, join_table: :order_details
    # attr_accessor :name, :category, :price
    # def initialize data
    #     @name = data[:name]
    #     @price = data[:price]
    #     @category = data[:category]
    # end
end


class Order < Sequel::Model
  one_to_many :order_details
  many_to_many :products, join_table: :order_details
end

class OrderDetail < Sequel::Model
  many_to_one :order
  many_to_one :product

  def total_price
    quantity * product.price
  end
end

# p list.map { |item| Product.new item }

# p Product.all.count

# y = Product.new(name: "Yogurth", category: "Dessert", price: 36)

# y.save

# p Product.all.count

# ap Product.all

# y.destroy

# p Product.all.count

# p Product.order(:id).last[:name]

order = Order.new(customer_name: "Coke")
order.save
ap order.methods.sort


products = Product.where(id: [2, 3]).all

products.each do |product|
  order.add_order_detail product: product, quantity: 3
end

order.order_details.each do |item|
  puts "#{item.product.name} #{item.quantity} -- #{item.total_price}"
end


puts "-----------------"

# ap list.count

ap order.order_details_dataset.all

puts "-----------------"

ap order.order_details

