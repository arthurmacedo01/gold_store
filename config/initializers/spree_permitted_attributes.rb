# config/initializers/spree_permitted_attributes.rb

Spree::PermittedAttributes.user_attributes << :store_id
Spree::PermittedAttributes.product_attributes << :store_id
Spree::PermittedAttributes.option_type_attributes << :store_id
Spree::PermittedAttributes.property_attributes << :store_id
Spree::PermittedAttributes.stock_item_attributes << :store_id
Spree::PermittedAttributes.taxonomy_attributes << :store_id

Spree::PermittedAttributes.user_attributes.concat([
  :full_name,
  :date_of_birth,
  :cpf,
  :rg,
  :marital_status,
  :company_name,
  :cnpj,
  :state_registration
])
