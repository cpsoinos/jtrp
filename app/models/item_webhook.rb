class ItemWebhook < ActiveRecord::Base
  belongs_to :item
  belongs_to :webhook
end
