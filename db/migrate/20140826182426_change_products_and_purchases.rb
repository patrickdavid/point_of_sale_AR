class ChangeProductsAndPurchases < ActiveRecord::Migration
  def change
    remove_column :products, :purchase_id
    add_column :purchases, :product_id, :integer
  end
end
