class ClientsPresenter

  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def filter
    if params[:status]
      Client.send(params[:status]).order(:id)
    else
      Client.all
    end
  end

end
