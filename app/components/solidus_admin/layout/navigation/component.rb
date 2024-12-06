# frozen_string_literal: true

class SolidusAdmin::Layout::Navigation::Component < SolidusAdmin::BaseComponent
  def initialize(
    current_user:,
    store:,
    logo_path: SolidusAdmin::Config.logo_path,
    items: SolidusAdmin::Config.menu_items
  )
    @logo_path = logo_path
    items = reject_leaf_properties(items) unless current_user.admin?
    @items = items.map do |attrs|
      children = attrs[:children].to_a.map { SolidusAdmin::MenuItem.new(**_1, top_level: false) }
      SolidusAdmin::MenuItem.new(**attrs, children:, top_level: true)
    end
    @store = store
  end

  def before_render
    url = @store.url
    url = "https://#{url}" unless url.start_with?("http")
    @store_url = url
  end

  def items
    @items.sort_by(&:position)
  end

  def reject_leaf_properties(items)
    items.map do |item|
      next if item[:key] == "legacy_promotions"
      # Recursively process children
      children = item[:children]&.map { |child| reject_leaf_properties([ child ]) }.flatten || []

      puts item[:key]


      # Only include items that don't match the reject criteria
      unless item[:key] == :display_order || item[:key] == :properties || item[:key] == :stores || item[:key] == :taxes || item[:key] == :checkout || item[:key] == :zones

        item.merge(children: children)
      end
    end.compact
  end
end
