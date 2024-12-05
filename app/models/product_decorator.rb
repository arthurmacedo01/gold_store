 module ProductDecorator
    def self.prepended(base)
      base.belongs_to :store, class_name: "Spree::Store", optional: true
    end
 end


Spree::Product.prepend ProductDecorator
