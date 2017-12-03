class StatementItem < ActiveRecord::Base
  belongs_to :statement
  belongs_to :item

  validates :statement, :item, presence: true
  validates :item, presence: true, uniqueness: { scope: :statement }
end
