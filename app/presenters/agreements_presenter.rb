class AgreementsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    if params[:status]
      Agreement.send(params[:status])
    else
      Agreement.all
    end
  end

end
