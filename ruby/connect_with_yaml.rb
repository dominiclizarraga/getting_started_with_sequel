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


p db[:products].columns


db[:products].insert(name: "Apple", category: "Fruit", price: 12)

db[:products].insert(name: "Veal", category: "Meat", price: 31)

db[:products].insert(name: "Brocoli", category: "Vegetable", price: 98)

db[:products].insert(name: "Tomato", category: "Fruit", price: 154)

db[:products].insert(name: "Hammer", category: "Tool", price: 100)

db[:products].insert(name: "Screwdriver", category: "Tool", price: 6)

db[:products].insert(name: "Onion", category: "Vegetable", price: 77)

list = db[:products].all

class Product < Sequel::Model
    # attr_accessor :name, :category, :price
    # def initialize data
    #     @name = data[:name]
    #     @price = data[:price]
    #     @category = data[:category]
    # end
end

# p list.map { |item| Product.new item }

p Product.all