class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :object, polymorphic: true
end
