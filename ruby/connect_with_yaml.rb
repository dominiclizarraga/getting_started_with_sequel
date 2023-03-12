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

Sequel::Model.plugin :validation_helpers

class Product < Sequel::Model
  one_to_many :order_details
  many_to_many :orders, join_table: :order_details
  # plugin :validation_helpers
    # attr_accessor :name, :category, :price
    # def initialize data
    #     @name = data[:name]
    #     @price = data[:price]
    #     @category = data[:category]
    # end

    def validate
      # errors.add :name, "should not be null" if name.nil? || name == ""
      validates_presence [:name, :category, :price], message: "pass a value please"
      validates_includes ["Vegetable", "Tool", "Dairy", "Meat"], :category
      # validates_max_length 3, :category
      # validates_min_length 3, :category
      # validates_exact_length 3, :category
      validates_numeric :price
      super
    end
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

# order = Order.new(customer_name: "Coke")
# order.save
# order.methods.sort


# products = Product.where(id: [2, 3]).all

# products.each do |product|
#   order.add_order_detail product: product, quantity: 3
# end

# order.order_details.each do |item|
#   "#{item.product.name} #{item.quantity} -- #{item.total_price}"
# end


# puts "-----------------"

# ap list.count

# order.order_details_dataset

# puts "-----------------"

# order.order_details

class OrderCreator
  def initialize data
    # data structure will be: [[id, quantity], [id, quantity]]
    @data = data.sort { |item, next_| item[0] <=> next_[0] }
  end

  def execute
    find_products
    # db.transaction do
      create_order
      add_items_to_order
    # end
    print_order
  end

  def find_products
    @products_ids = @data.map { |row| row[0] } 
    @products = Product.order(:id).where(id: @products_ids).all
  end

  def create_order
    @order = Order.new
    @order.save
  end

  def add_items_to_order
    quantities = @data.map { |row| row[1] }
    order_items_data = @products.zip quantities
    order_items_data.each do |item|
      @order.add_order_detail product: item[0], quantity: item[1]
    end
  end

  def print_order
    @order.order_details.each do |item|
      puts "#{item.product.name} #{item.quantity} -- #{item.total_price}"
    end
  end

end

# OrderCreator.new([[2, 2],[4, 5]]).execute


# -------------- Sequel validations -------------- 

ap soda = Product.new(name: "soda")
ap soda.valid?
ap soda.save
























