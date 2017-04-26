class ItemsPresenter

  attr_reader :params, :resource, :filters, :query

  def initialize(params={}, resource=nil)
    @params = params
    @resource = resource
    @items = item_base.includes(:account, proposal: {job: {account: :primary_contact}})
    @filters = params[:filters] || {}
    @query = filters.delete(:query)
  end

  def filter
    @items = @items.filter(filters)
    self
  end

  def sort
    @items = @items.order(params[:order])
    self
  end

  def paginate
    return self if params[:labels].present?
    @items = @items.page(params[:page])
    self
  end

  def search
    return self if query.blank?
    @items = @items.includes(:pg_search_document).joins(:pg_search_document).merge(PgSearch.multisearch(query))
    self
  end

  def execute
    filter.search.sort.paginate
    @items
  end

  def todo
    @items.where(id: (no_listing_price | no_sale_price))
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
