class CreateCashiersCustomers < ActiveRecord::Migration
  def change
    create_table :cashiers_customers do |t|
      t.column :cashier_id, :integer
      t.column :customer_id, :integer

      t.timestamps
    end
  end
end
