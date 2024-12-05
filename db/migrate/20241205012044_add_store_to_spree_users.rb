class AddStoreToSpreeUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :spree_users, :store, foreign_key: { to_table: :spree_stores }
  end
end
