class AgreementCreator

  attr_reader :user, :proposal

  def initialize(user)
    @user = user
  end

  def create(proposal)
    @proposal = proposal
    generate_agreements
    @agreements
  end

  private

  def generate_agreements
    @agreements ||= begin
      types.map do |type|
        next if type.in?(%w(undecided decline nothing))
        Agreement.find_or_create_by!(proposal: proposal, agreement_type: type)
      end.compact
    end
  end

  def types
    @_types ||= proposal.items.pluck(:client_intention).uniq
  end

end
