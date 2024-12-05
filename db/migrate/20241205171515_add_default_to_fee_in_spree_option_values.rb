class AddDefaultToFeeInSpreeOptionValues < ActiveRecord::Migration[6.0]
  def change
    # Set all existing NULL values to 0
    Spree::OptionValue.where(fee: nil).update_all(fee: 0)

    # Change the column to include NOT NULL and default constraints
    change_column :spree_option_values, :fee, :decimal, precision: 10, scale: 2, default: 0, null: false
  end
end
