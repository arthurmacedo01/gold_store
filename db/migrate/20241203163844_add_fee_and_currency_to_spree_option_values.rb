class AddFeeAndCurrencyToSpreeOptionValues < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_option_values, :fee, :decimal, precision: 10, scale: 2
    add_column :spree_option_values, :currency, :string
  end
end
