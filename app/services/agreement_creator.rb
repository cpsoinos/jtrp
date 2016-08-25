class AgreementCreator

  attr_reader :user, :proposal

  def initialize(user)
    @user = user
  end

  def create(proposal)
    @proposal = proposal
    generate_agreements
    generate_agreement_pdfs
    @agreements
  end

  private

  def generate_agreements
    @agreements ||= begin
      types.map do |type|
        next if type == "undecided" || type == "nothing"
        Agreement.find_or_create_by!(proposal: proposal, agreement_type: type)
      end.compact
    end
  end

  def generate_agreement_pdfs
    @agreements.each do |agreement|
      PdfGeneratorJob.perform_later(agreement)
    end
  end

  def types
    @_types ||= proposal.items.pluck(:client_intention).uniq
  end

end
