module GoldStore
  module PermissionSets
    class StoreManage < Spree::PermissionSets::Base
      class << self
        def privilege
          :management
        end

        def category
          :order
        end
      end

      def activate!
        current_user = @ability.user
        can :manage, :all
        cannot :manage, Spree::Product
        can :manage, Spree::Product, store_id: [ nil, current_user.store_id ]
        cannot :manage, Spree::Order
        can :manage, Spree::Order, store_id: [ nil, current_user.store_id ]
        cannot :manage, Spree::User
        can :manage, Spree::User, store_id: current_user.store_id
        cannot :manage, Spree::OptionType
        can :manage, Spree::OptionType, store_id: [ nil, current_user.store_id ]
        cannot :manage, Spree::Property
        can :manage, Spree::Property, store_id: [ nil, current_user.store_id ]
        cannot :manage, Spree::StockItem
        can :manage, Spree::StockItem, store_id: [ nil, current_user.store_id ]
        cannot :manage, Spree::Taxonomy
        can :manage, Spree::Taxonomy, store_id: [ nil, current_user.store_id ]

        cannot :manage, Spree::Role
        cannot :manage, Spree::Store
        cannot :manage, Spree::PaymentMethod
        cannot :manage, Spree::Zone
        cannot :manage, Spree::ShippingMethod
        cannot :manage, Spree::RefundReason
        cannot :manage, Spree::TaxCategory
      end
    end
  end
end
