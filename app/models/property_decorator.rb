 module PropertyDecorator
    def self.prepended(base)
      base.belongs_to :store, class_name: "Spree::Store", optional: true
    end
 end


Spree::Property.prepend PropertyDecorator
