# there are 2 ways to install Sequel 

# 1. pass a URI string (currently using in the beginning of the tutorial)

# 2. pass a hash of options (this is good when you have different enviroments - https://edgeguides.rubyonrails.org/configuring.html#connection-preference)


# in the command write 'bundle exec irb' to have an interactive window

# then run `Bundler.require` # you'll see all the dependencies

# then run `Sequel.connect "sqlite://db.sqlite3"` # it will thow an object

# => #<Sequel::SQLite::Database: "sqlite://db.sqlite3">

# we will instantiate the object on the next variable 'db' so run:

`db = Sequel.connect "sqlite://db.sqlite3"`

# if we run `db[:posts]` we will get a `dataset`

=> #<Sequel::SQLite::Dataset: "SELECT * FROM `posts`">

# ============ read data ============


# if we run `db[:posts].first`

# => Sequel::DatabaseError (SQLite3::SQLException: no such table: posts)

# => db.run "CREATE TABLE fruits (id integer primary key autoincrement, name varchar(255), category varchar(255))"

# to see the columns db[:fruits].columns

# => to insert values

# db[:fruits].insert(name: "Apple", category: "Fruit")

# db[:fruits].insert(name: "Veal", category: "Meat")

# db[:fruits].insert(name: "Brocoli", category: "Vegetable")

# db[:fruits].insert(name: "Tomato", category: "Fruit")

# db[:fruits].insert(name: "Hammer", category: "Tool")

# db[:fruits].insert(name: "Screwdriver", category: "Tool")

# db[:fruits].insert(name: "Onion", category: "Vegetable")

# db[:fruits].to_a.count 

# => 7 

# if you want to look up the id: 1, you can do `.where(property: ?)` note the difference when you call `.all` and `.first`

# db[:fruits].where(id: 1).all

# => [{:id=>1, :name=>"Apple", :category=>"Fruit"}]

# db[:fruits].where(id: 1).first

# => {:id=>1, :name=>"Apple", :category=>"Fruit"}

# remember this pattern, first we get load of different buildings methods that chain the dataset to be fetched and then we perfom the operation to actually retrieve data

# the first building block (where), the second is executable (`.last`,`.frist`,`.all`)

# another building block is `.order`

# db[:fruits].order(:id).last

# another is that we can use many buidling methods together 

# db[:fruits].where(id: 0..5).order(:id).last

# db[:fruits].where(id: 0..5).order(:name).all

# [{:id=>1, :name=>"Apple", :category=>"Fruit"}, {:id=>3, :name=>"Brocoli", :category=>"Vegetable"}, {:id=>5, :name=>"Hammer", :category=>"Tool"}, {:id=>4, :name=>"Tomato", :category=>"Fruit"}, {:id=>2, :name=>"Veal", :category=>"Meat"}]

# db[:fruits].where(id: [1, 3, 5]).order(:name).all

# => [{:id=>1, :name=>"Apple", :category=>"Fruit"}, {:id=>3, :name=>"Brocoli", :category=>"Vegetable"}, {:id=>5, :name=>"Hammer", :category=>"Tool"}]

# with regex operators

# => db[:fruits].where(Sequel.like(:name, "%p%")).order(:name).first

# {:id=>1, :name=>"Apple", :category=>"Fruit"}


# first join between 2 tables (db.tables)

# db[:fruits].left_outer_join(:prices, id: :id).all

# [{:id=>1, :name=>"Apple", :category=>"Fruit", :price=>12.0}, {:id=>2, :name=>"Veal", :category=>"Meat", :price=>3.0}, {:id=>3, :name=>"Brocoli", :category=>"Vegetable", :price=>43.0}, {:id=>4, :name=>"Tomato", :category=>"Fruit", :price=>65.0}, {:id=>5, :name=>"Hammer", :category=>"Tool", :price=>6.0}, {:id=>6, :name=>"Screwdriver", :category=>"Tool", :price=>77.0}, {:id=>7, :name=>"Onion", :category=>"Vegetable", :price=>100.0}]

# using math operations

# db[:fruits].where{price > 100}.all

# db[:fruits].where{price >= 100}.reverse_order(:name).all

# alter a table 

# db.run "ALTER TABLE fruits ADD price float"

# then to update the rows we can run:

# db[:fruits].where(id: 1).update(price: 12)

# limit function

# db[:fruits].limit(3).all

# [{:id=>1, :name=>"Apple", :category=>"Fruit", :price=>12.0}, {:id=>2, :name=>"Veal", :category=>"Meat", :price=>14.0}, {:id=>3, :name=>"Brocoli", :category=>"Vegetable", :price=>44.0}]

# usage of offset()

# db[:fruits].limit(3).offset(2).all

# [{:id=>3, :name=>"Brocoli", :category=>"Vegetable", :price=>44.0}, {:id=>4, :name=>"Tomato", :category=>"Fruit", :price=>65.0}, {:id=>5, :name=>"Hammer", :category=>"Tool", :price=>145.0}]


# ============ inserting data ============


# db[:fruits].insert(name: "Yogurth", category: "Dairy", price: 33)

# id = db[:fruits].insert(name: "Yogurth", category: "Dairy", price: 330)

# db[:fruits].where(id: id)

# db[:fruits].where(name: "Yogurth").first[:name]

# => "Yogurth"

# select all names

# => db[:fruits].select(:name).all

# [{:name=>"Apple"}, {:name=>"Veal"}, {:name=>"Brocoli"}, {:name=>"Tomato"}, {:name=>"Hammer"}, {:name=>"Screwdriver"}, {:name=>"Onion"}, {:name=>"Grape"}, {:name=>"Sabritas"}, {:name=>"Yogurth"}, {:name=>"Yogurth"}]

# ============ updating data ============

# remember first start with the building block, chunk by chunk, then the execure block in this case the `where` then the `update`

# db[:fruits].where(name: "Yogurth").update(name: "Y")


# ============ deleteing data ============

# db[:fruits].where(id: 11).delete

# db[:fruits].where(id: 2..4).delete


# ============ models ============










