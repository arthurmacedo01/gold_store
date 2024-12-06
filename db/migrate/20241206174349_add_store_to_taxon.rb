class AddStoreToTaxon < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:spree_taxons, :store_id)
      add_reference :spree_taxons, :store, foreign_key: { to_table: :spree_stores }
    end
  end
end
