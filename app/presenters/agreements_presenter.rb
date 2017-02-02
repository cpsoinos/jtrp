class AgreementsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    Agreement.includes(:proposal, :job, :account, {proposal: [:account, :primary_contact]}).filter(params.slice(:status))
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
