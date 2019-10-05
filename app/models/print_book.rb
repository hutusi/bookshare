class PrintBook < ApplicationRecord
  # personal book is only seen by self, borrowable book is seen by others and can be borrowed.
  # shared book is shared to others.
  enum property: { personal: 0, borrowable: 50, shared: 100 }
  enum status: { available: 0, reading: 55, not_found: 99 }

  belongs_to :book
  belongs_to :owner, class_name: 'User'
  belongs_to :holder, class_name: 'User'
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  belongs_to :deal, optional: true
  belongs_to :last_deal, class_name: 'Deal', optional: true
end
