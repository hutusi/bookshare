class PrintBook < ApplicationRecord
  # private book is only seen by self, public book is seen by others and can be borrowed.
  # shared book is shared to others.
  enum property: [ private: 0, public: 50, shared: 100 ]
  enum status: [ available: 0, reading: 55, not_found: 99 ]

  belongs_to :book
  belongs_to :owner, class_name: 'User'
  belongs_to :holder, class_name: 'User'
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
end
