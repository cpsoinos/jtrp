class ItemsPresenter

  attr_reader :params, :resource

  def initialize(params={}, resource=nil)
    @params = params
    @resource = resource
    @items = item_base
  end

  def filter
    @items = @items.filter(params.slice(:status, :type, :by_id, :by_category_id))
    self
  end

  def sort
    @items = @items.order(params[:order])
    self
  end

  def paginate
    @items = @items.page(params[:page])
    self
  end

  def search
    @items = @items.includes(:pg_search_document).joins(:pg_search_document).merge(PgSearch.multisearch(params[:query]))
    self
  end

  def execute
    filter.sort.paginate
    @items
  end

  def todo
    Item.includes(:account, proposal: {job: {account: :primary_contact}}).where(id: (no_listing_price | no_sale_price))
  end

  private

  def no_listing_price
    Item.for_sale.where(listing_price_cents: nil).pluck(:id)
  end

  def no_sale_price
    Item.sold.where(sale_price_cents: nil).pluck(:id)
  end

  def item_base
    if resource
      resource.items
    else
      Item
    end
  end

end
