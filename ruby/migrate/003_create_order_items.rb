Sequel.migration do
  change do
    create_table :order_items do
      primary_key :id
      foreign_key :product_id, :products, null: false
      foreign_key :order_id,   :orders,   null: false
      Integer :quantity
    end
  end

  # alter_table do
  #   adding_column :blah
  #   dropping_column :blah
  # end
end 

# run in the terminal `sequel -m migrate URI_where_db_is`