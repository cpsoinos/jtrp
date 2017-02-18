class Webhook < ActiveRecord::Base

  def objects
    return [] unless data["appId"]== ENV["CLOVER_APP_ID"]
    data["merchants"][ENV["CLOVER_MERCHANT_ID"]]
  end

end
