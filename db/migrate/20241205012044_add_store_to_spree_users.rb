class AddStoreToSpreeUsers < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:spree_users, :store_id)
      add_reference :spree_users, :store, null: false, foreign_key: true
    end

    # Set default store for existing users
    reversible do |dir|
      dir.up do
        default_store = Spree::Store.first
        Spree::User.update_all(store_id: default_store.id) if default_store.present?
      end
    end
  end
end
