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
    Agreement.includes(account: :primary_contact)
      .by_type('consign')
      .active
      .joins(proposal: :items)
      .merge(
        Item.consigned.where("listed_at < ?", 80.days.ago)
      ).tagged_with('unexpireable', exclude: true)
  end

end
