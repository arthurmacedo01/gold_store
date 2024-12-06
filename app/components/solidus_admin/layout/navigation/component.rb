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
    items.reject! { |item| item[:key] == :settings || item[:key] == "legacy_promotions" }

    items.reject do |item|
      item[:key] == :display_order || item[:key] == :properties || (item[:children] ||= []).any? && (item[:children] = reject_leaf_properties(item[:children])).empty?
    end
  end
end
