class AgreementsPresenter

  attr_reader :params, :filters

  def initialize(params={})
    @params = params
    @filters = params[:filters] || {}
  end

  def filter
    Agreement.includes(:proposal, :job, account: :primary_contact).filter(filters)
  end

  def todo
    Agreement.includes(:items, :letters, account: :primary_contact)
      .by_type('consign')
      .active
      .joins(:items)
      .tagged_with(['unexpireable', 'items_retrieved'], exclude: true)
      .merge(
        Item.pending_expiration
      )
  end

end
