class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.column :quantity, :integer
      t.column :product_id, :integer
      t.column :sales_id, :integer

      t.timestamps
    end
  end
end
