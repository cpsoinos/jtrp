class TransactionalEmailRecord < ApplicationRecord
  acts_as_paranoid
  audited

  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id", optional: true
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id", optional: true
end
