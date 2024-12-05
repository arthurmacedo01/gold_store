  # app/models/spree/user_decorator.rb

  module UserDecorator
    def self.prepended(base)
      base.belongs_to :store, class_name: "Spree::Store", optional: true
    end
  end


Spree::User.prepend UserDecorator
