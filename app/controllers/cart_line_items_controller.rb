# frozen_string_literal: true

class CartLineItemsController < StoreController
  helper "spree/products", "orders"

  respond_to :html

  before_action :store_guest_token

  # Adds a new item to the order (creating a new order if none already exists)
  def create
    product_variants = Spree::Variant.where(variant_params)

    option_value_ids = Array(params[:option_value_ids]) # Ensure it's an array
    option_values = Spree::OptionValue.where(id: option_value_ids) # Fetch valid option values

    if option_values.present?
      variant = product_variants
                        .joins(:option_values)
                        .where(option_values: { id: option_value_ids })
                        .group("spree_variants.id")
                        .having("COUNT(option_values.id) = ?", option_value_ids.size)
                        .having("array_agg(option_values.id ORDER BY option_values.id) = ARRAY[?]::integer[]", option_value_ids.sort)
                        .first
    else
      variant = product_variants.first
    end

    # If no variant matches, create a new one
    if variant.nil?
      # Create the variant with the provided params
      variant = Spree::Variant.create!(variant_params)
      # Associate the option values with the variant
      variant.option_values << option_values
    end

    # Calculate the new price
    new_amount = variant.product.price + option_values.sum(:fee)

    # Create or update the price for the variant
    price = Spree::Price.find_or_initialize_by(variant_id: variant.id)
    price.update!(amount: new_amount) if price.amount != new_amount

    # Reload the variant to reflect the updated price
    variant.reload


    quantity = params[:quantity].present? ? params[:quantity].to_i : 1

    @order = current_order(create_order_if_necessary: true)
    authorize! :update, @order, cookies.signed[:guest_token]

    # 2,147,483,647 is crazy. See issue https://github.com/spree/spree/issues/2695.
    if !quantity.between?(1, 2_147_483_647)
      @order.errors.add(:base, t("spree.please_enter_reasonable_quantity"))
    else
      begin
        @line_item = @order.contents.add(variant, quantity)
      rescue ActiveRecord::RecordInvalid => error
        @order.errors.add(:base, error.record.errors.full_messages.join(", "))
      end
    end

    respond_to do |format|
      format.html do
        if @order.errors.any?
          flash[:error] = @order.errors.full_messages.join(", ")
          redirect_back_or_default(root_path)
          return
        else
          redirect_to cart_path
        end
      end
    end
  end

  private

  def store_guest_token
    cookies.permanent.signed[:guest_token] = params[:token] if params[:token]
  end

  def variant_params
    params.require(:variant).permit(
      :product_id, :sku, :price, :cost_price, :cost_currency, :weight, :height, :width, :depth,
      :tax_category_id, :shipping_category_id, :track_inventory,
    )
  end
end
