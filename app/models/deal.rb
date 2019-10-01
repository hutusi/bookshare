class Deal < ApplicationRecord
  belongs_to :print_book
  belongs_to :book
  belongs_to :sponsor, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
end
