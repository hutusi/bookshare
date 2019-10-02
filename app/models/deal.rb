class Deal < ApplicationRecord
  # borrow status: initial, lending, borrowing, returning, finished
  # share status: initial, lending, borrowing
  enum status: { initial: 0, lending: 20, borrowing: 60, returning: 90, finished: 100 }

  belongs_to :print_book
  belongs_to :book
  belongs_to :sponsor, class_name: 'User'
  belongs_to :receiver, class_name: 'User', optional: true
end
