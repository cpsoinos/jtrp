class Webhook < ActiveRecord::Base

  def objects
    data["merchants"][ENV["CLOVER_MERCHANT_ID"]]
  end

end
