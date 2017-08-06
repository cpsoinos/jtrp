module AccountStateMachine
  extend ActiveSupport::Concern

  included do

    state_machine :status, initial: :potential do
      state :potential
      state :active
      state :inactive

      after_transition potential: :inactive, do: :deactivate_items

      event :mark_active do
        transition [:potential, :inactive] => :active, if: lambda { |account| account.meets_requirements_active? }
      end

      event :mark_inactive do
        transition active: :inactive, if: lambda { |account| account.meets_requirements_inactive? }
        transition potential: :inactive
      end

      event :reactivate do
        transition inactive: :active
      end

    end

    def meets_requirements_active?
      jobs.active.present?
    end

    def meets_requirements_inactive?
      jobs.present? && jobs.completed.count == jobs.count
    end

  end
end
