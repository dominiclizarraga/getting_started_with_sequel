Sequel.migration do
  up do
    create_table :products do
      primary_key :id
      String :name
      String :category
      Float :price
      Time :created_at
      Time :updated_at
    end
  end

  down do
    drop_table :products
  end
end 

# run in the terminal `sequel -m migrate URI_where_db_is`