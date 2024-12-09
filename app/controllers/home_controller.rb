# frozen_string_literal: true

class HomeController < StoreController
  helper "spree/products"
  respond_to :html

  def index
    Rails.logger.info "request: #{request} servername: #{request.env['SERVER_NAME']}"
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @products = Spree::Product.available.where(store_id: current_store.id).order(available_on: :desc)
    # Split products into groups of 3 for the homepage blocks.
    # You probably want to remove this logic and use your own!
    homepage_groups = @products.in_groups_of(3, false)
    @featured_products = homepage_groups[0]
    @collection_products = homepage_groups[1]
    @cta_collection_products = homepage_groups[2]
    @new_arrivals = homepage_groups[3]
  end
end
