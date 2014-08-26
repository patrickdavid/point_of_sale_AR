class ChangePurchasesAndProducts < ActiveRecord::Migration
  def change
    remove_column :purchases, :product_id
    add_column :products, :purchase_id, :integer
  end
end
