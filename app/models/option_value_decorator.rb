  # app/models/option_value_decorator.rb

  module OptionValueDecorator
    def self.prepended(base)
      base.validates :free, presence: true
    end
  end


Spree::OptionValue.prepend OptionValueDecorator
