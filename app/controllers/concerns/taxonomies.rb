# frozen_string_literal: true

module Taxonomies
  extend ActiveSupport::Concern
  included do
    helper_method :taxonomies
  end

  protected

  def taxonomies
    @taxonomies ||= Spree::Taxonomy.where(store_id: current_store.id).includes(root: :children)
  end
end
