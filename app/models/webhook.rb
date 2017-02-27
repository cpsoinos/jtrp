class Webhook < ActiveRecord::Base
  has_many :webhook_entries

  def remote_entries
    begin
      data["merchants"][ENV["CLOVER_MERCHANT_ID"]]
    rescue NoMethodError => e
      []
    end
  end

  def clover?
    integration == 'clover'
  end

  def lob?
    integration == 'lob'
  end

end
