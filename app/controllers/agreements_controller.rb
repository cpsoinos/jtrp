class AgreementsController < ApplicationController

  def index
    @proposal = Proposal.find(params[:proposal_id])
    @client = @proposal.client
    # @intentions = @proposal.items.where.not(client_intention: "nothing").pluck(:client_intention).uniq
    @agreements = @proposal.agreements
    @items = @proposal.items
    gon.signatures = build_json_for_signatures
  end

  def create
    @proposal = Proposal.find(params[:proposal_id])
    @client = @proposal.client
    # @items = @proposal.items
    @intentions = ["consign", "dump"]
    AgreementCreator.new(@proposal).create(@intentions)

    # @intentions = @proposal.items.where.not(client_intention: "nothing").pluck(:client_intention).uniq
    redirect_to proposal_agreements_path(@proposal)
    # gon.signatures = build_json_for_signatures
  end

  def update
    @agreement = Agreement.find(params[:id])
    if @agreement.update(signature_params)
      @agreement.mark_active
      respond_to do |format|
        format.html
        format.js do
          @role = params[:role]
        end
      end
    end
  end

  protected

  def signature_params
    key = "#{params[:role]}_signature".to_sym
    { key => params[:signature] }
  end

  def build_json_for_signatures
    signatures = begin
      @agreements.each do |agreement|
        {
          manager: agreement.manager_signature,
          client: agreement.client_signature
        }
      end
    end
    # @agreements.map do |agreement|
    # signatures = {
    #   manager: agreement.manager_signature,
    #   client: agreement.client_signature
    # }

    signatures
  end

end
