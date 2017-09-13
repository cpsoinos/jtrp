module Agreements
  class ItemGatherer

    attr_reader :agreement, :proposal

    def initialize(agreement, proposal)
      @agreement = agreement
      @proposal  = proposal
    end

    def execute
      gather_items
    end

    private

    def gather_items
      agreement.items << items
    end

    def items
      @_items ||= proposal.items.where(client_intention: agreement.agreement_type)
    end

  end
end
