class Item < ApplicationRecord
    
    validates :price, :description, :stockQty, presence: true
    validates :price, numericality: { greater_than: 0 }
    validates :stockQty, numericality: { only_integer: true , greater_than: -1} 
    
end