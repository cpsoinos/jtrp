class ItemsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Item.includes(:photos, proposal: [job: [account: :primary_contact]]).filter(params.slice(:status, :type, :by_id))
  end

  def todo
    Item.where(id: (no_listing_price | no_sale_price))
  end

  private

  def no_listing_price
    Item.for_sale.where(listing_price_cents: nil).pluck(:id)
  end

  def no_sale_price
    Item.sold.where(sale_price_cents: nil).pluck(:id)
  end

end
