class AgreementCreator

  attr_reader :proposal, :types

  def initialize(proposal)
    @proposal = proposal
  end

  def create(types)
    @types = types
    generate_agreements
  end

  private

  def generate_agreements
    @_agreements ||= begin
      types.each do |type|
        Agreement.find_or_create_by!(proposal: proposal, agreement_type: type)
      end
    end
  end

end
