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
        cannot :manage, Spree::Order
        can :manage, Spree::Order, store_id: current_user.store_id

        cannot :manage, Spree::User
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
