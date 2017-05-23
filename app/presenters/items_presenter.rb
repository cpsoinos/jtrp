class ItemsPresenter

  attr_reader :params, :resource, :filters, :query, :labels, :items

  def initialize(params={}, items=nil)
    @params = params
    @resource = resource
    @query = params.delete(:query) || params.delete(:search)
    @labels = params.delete(:labels)
    @sort = params.delete(:sort) || "description"
    @order = params.delete(:order)
    @limit = params.delete(:limit) || 25
    @offset = params.delete(:offset) || 0
    @filters = params
    @items ||= item_base
  end

  def filter
    @items = @items.filter(filters)
    self
  end

  def sort
    @items = @items.order("#{@sort} #{@order}")
    self
  end

  def total
    @items.count
  end

  def paginate
    return self if labels.present?
    # @items = @items.page(params[:page])
    @items = @items.offset(@offset).limit(@limit)
    self
  end

  def search
    return self if query.blank?
    @items = @items.joins(:pg_search_document).merge(PgSearch.multisearch(query))
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
