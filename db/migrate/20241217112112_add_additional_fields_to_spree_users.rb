class AddAdditionalFieldsToSpreeUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_users, :full_name, :string
    add_column :spree_users, :date_of_birth, :date
    add_column :spree_users, :cpf, :string
    add_column :spree_users, :rg, :string
    add_column :spree_users, :marital_status, :string
    add_column :spree_users, :company_name, :string
    add_column :spree_users, :cnpj, :string
    add_column :spree_users, :state_registration, :string
  end
end
