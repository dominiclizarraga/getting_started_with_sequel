Sequel.migration do
  up do
    create_table :products do
      primary_key :id
    end
  end

  down do
    drop_table :products
  end
end 

# run in the terminal `sequel -m migrate URI_where_db_is`