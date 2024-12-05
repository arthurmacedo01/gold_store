class AddStoreToSpreeUsers < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:spree_users, :store_id)
      add_reference :spree_users, :store, foreign_key: { to_table: :spree_stores }
    end
  end
end
