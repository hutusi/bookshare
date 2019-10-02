class Deal < ApplicationRecord
  # borrow status: available, requesting, lending, borrowing, returning, finished
  # share status: available, requesting, lending, borrowing
  enum status: { available: 0, requesting: 20, lending: 40, borrowing: 60, returning: 90, finished: 100 }

  belongs_to :print_book
  belongs_to :book
  belongs_to :sponsor, class_name: 'User'
  belongs_to :receiver, class_name: 'User', optional: true
  belongs_to :applicant, class_name: 'User', optional: true
end
