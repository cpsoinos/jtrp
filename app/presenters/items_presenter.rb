class ItemsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Item.filter(params.slice(:status, :type))
  end

  def todo
    no_listing_price
  end

  private

  def no_listing_price
    Item.for_sale.where(listing_price_cents: nil)
  end

end
