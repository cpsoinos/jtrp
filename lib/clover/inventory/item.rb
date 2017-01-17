module Clover
  module Inventory
    class Item
      include Her::Model
      collection_path "v3/merchants/#{ENV['CLOVER_MERCHANT_ID']}/items"

    end
  end
end
