class ItemsPresenter
  include DataPaginatable

  attr_reader :filters, :query, :params, :resource

  def initialize(params={}, items=nil)
    @filters = params[:filters]
    @query   = params[:query] || params[:search]
    @params  = params
  end

  def for_resource(resource)
    @resource = resource
    self
  end

  def execute
    filter.search.order_by.paginate.rows
  end

  def filtered_total
    filter.rows.uniq.count
  end

  def total_count
    rows.uniq.count
  end

  def order_by
    @rows = rows.order("#{sort_column} #{sort_direction} NULLS LAST")
    self
  end

  def sortable_columns
    ["items.id", "items.description", "items.status", "accounts.slug", "items.account_item_number", "items.purchase_price_cents", "items.listing_price_cents", "items.sale_price_cents", "items.sold_at"]
  end

  def default_sort
    sortable_columns.first
  end

  def filter
    if filters.present?
      @rows = rows.filter(filters)
    end
    self
  end

  def total_count
    rows.uniq.count
  end

  def search
    return self if query.blank?
    @rows = rows.joins(:pg_search_document).merge(PgSearch.multisearch(query))
    self
  end

  def rows
    @rows ||= item_base.all
  end

  def todo
    items.where(id: (no_listing_price | no_sale_price))
  end

  private

  def no_listing_price
    Item.for_sale.where(listing_price_cents: nil).pluck(:id)
  end

  def no_sale_price
    Item.sold.where(sale_price_cents: nil).pluck(:id)
  end

  def item_base
    if resource.present?
      resource.items
    else
      Item
    end
  end

end
