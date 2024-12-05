class AddStoreReferenceToSpreeTables < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:spree_products, :store_id)
      add_reference :spree_products, :store, foreign_key: { to_table: :spree_stores }
    end
    unless column_exists?(:spree_option_types, :store_id)
      add_reference :spree_option_types, :store, foreign_key: { to_table: :spree_stores }
    end
    unless column_exists?(:spree_properties, :store_id)
      add_reference :spree_properties, :store, foreign_key: { to_table: :spree_stores }
    end
    unless column_exists?(:spree_stock_items, :store_id)
      add_reference :spree_stock_items, :store, foreign_key: { to_table: :spree_stores }
    end
    unless column_exists?(:spree_taxonomies, :store_id)
          add_reference :spree_taxonomies, :store, foreign_key: { to_table: :spree_stores }
    end
  end
end
