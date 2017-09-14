class AgreementItem < ApplicationRecord
  belongs_to :agreement
  belongs_to :item

  validates :agreement, presence: true
  validates :item, presence: true
end
