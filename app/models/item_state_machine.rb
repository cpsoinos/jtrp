module ItemStateMachine
  extend ActiveSupport::Concern

  included do
    state_machine :status, initial: :potential do
      state :potential
      state :active
      state :sold
      state :inactive

      after_transition [:potential, :inactive] => :active, do: [:set_listed_at, :sync_inventory, :mark_agreement_active]
      after_transition [:active, :inactive] => :sold, do: [:mark_agreement_inactive, :set_sold_at, :sync_inventory]
      after_transition any => :inactive, do: :sync_inventory
      after_transition sold: :active, do: [:clear_sale_data, :mark_agreement_active]

      event :mark_active do
        transition [:potential] => :active, if: lambda { |item| item.meets_requirements_active? }
        transition [:inactive] => :active
      end

      event :mark_sold do
        transition [:active, :inactive] => :sold, if: lambda { |item| item.meets_requirements_sold? }
      end

      event :mark_inactive do
        transition any => :inactive
      end

      event :mark_not_sold do
        transition :sold => :active
      end

    end

    def mark_agreement_inactive
      agreement.mark_inactive unless import? || expired?
    end

    def meets_requirements_active?
      if import?
        # bypass agreement requirement
        true
      else
        agreement.try(:active?)
      end
    end

    def meets_requirements_sold?
      !potential?
    end

  end
end
