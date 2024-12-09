class AddTmpStoreToSpreeUsers < ActiveRecord::Migration[7.2]
  unless column_exists?(:spree_users, :tmp_store_id)
    add_reference :spree_users, :tmp_store, foreign_key: { to_table: :spree_stores }
  end
end
