class OrderWebhook < ActiveRecord::Base
  belongs_to :order
  belongs_to :webhook
end
