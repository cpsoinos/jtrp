class ItemWebhook < ApplicationRecord
  belongs_to :item
  belongs_to :webhook
end
