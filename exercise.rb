database = Sequel.sqlite('database.sqlite3')

database.run "CREATE TABLE people (id integer primary key autoincrement, name varchar(255))"

database.schema(:people) # => []

database.insert(name: "juan")

database[:people].all # => [{:id=>1, :name=>"juan"}]

databse[:people].insert(name: "GEORGE")

databse[:people].insert(name: "Douglas")

database[:people].columns # => [:id, :name]

db = database.from(:people) # => assigning to a dataset

db.grep(:name, "j%").all # => juan

 db.where(id: [2, 3]).all # => [{:id=>2, :name=>"GEORGE"}, {:id=>3, :name=>"Thomas"}]
 
 db.count # => 3
