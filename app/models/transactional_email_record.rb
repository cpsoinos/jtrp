class TransactionalEmailRecord < ActiveRecord::Base
  audited
  include Streamable
  
  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
end
