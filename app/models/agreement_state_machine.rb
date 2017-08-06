module AgreementStateMachine
  extend ActiveSupport::Concern

  included do

    state_machine :status, initial: :potential do
      state :potential
      state :active
      state :inactive

      after_transition potential: :active, do: [:mark_proposal_active, :set_agreement_date, :save_as_pdf, :deliver_to_client, :notify_company, :save_item_descriptions]
      after_transition active: :inactive, do: :mark_proposal_inactive

      event :mark_active do
        transition [:potential, :inactive] => :active, if: lambda { |agreement| agreement.meets_requirements_active? }
      end

      event :mark_inactive do
        transition active: :inactive, if: lambda { |agreement| agreement.meets_requirements_inactive? }
      end

    end

    def meets_requirements_active?
      client_signed?
    end

    def meets_requirements_inactive?
      items.active.empty? && items.potential.empty?
    end

  end
end
