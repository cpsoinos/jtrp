class OrderWebhook < ApplicationRecord
  belongs_to :order
  belongs_to :webhook
end
