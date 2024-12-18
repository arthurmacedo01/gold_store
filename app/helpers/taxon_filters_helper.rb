# frozen_string_literal: true

require 'spree/core/product_filters'

module TaxonFiltersHelper
  def applicable_filters_for(_taxon)
    store_id = current_store.id
    [:brand_filter, :price_filter].map do |filter_name|      
      Spree::Core::ProductFilters.send(filter_name,store_id) if Spree::Core::ProductFilters.respond_to?(filter_name)
    end.compact
  end
end
