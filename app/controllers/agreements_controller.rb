class AgreementsController < ApplicationController
  before_filter :require_internal

  def index
    @proposal = Proposal.find(params[:proposal_id])
    @client = @proposal.client
    @agreements = @proposal.agreements
    @items = @proposal.items
    gon.signatures = build_json_for_signatures
  end

  def create
    @proposal = Proposal.find(params[:proposal_id])
    @client = @proposal.client
    @intentions = ["consign", "dump", "donate", "sell", "move"]
    AgreementCreator.new(@proposal).create(@intentions)
    redirect_to proposal_agreements_path(@proposal)
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
    signatures
  end

end
