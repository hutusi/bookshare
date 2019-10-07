class PrintBook < ApplicationRecord
  # personal book is only seen by self, borrowable book is seen by others and can be borrowed.
  # shared book is shared to others.
  enum property: { personal: 0, borrowable: 50, shared: 100 }
  enum status: { available: 0, reading: 55, losted: 99 }

  belongs_to :book
  belongs_to :owner, class_name: 'User'
  belongs_to :holder, class_name: 'User'
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  belongs_to :deal, optional: true
  belongs_to :last_deal, class_name: 'Deal', optional: true

  scope :personal, -> { where(property: :personal) }
  scope :for_borrow, -> { where(property: :borrowable) }
  scope :borrowable, -> { where(property: :borrowable, status: :available) }
  scope :borrowing, -> { where(property: :borrowable, status: :reading) }
  scope :for_share, -> { where(property: :shared) }
  scope :shareable, -> { where(property: :shared, status: :available) }
  scope :sharing, -> { where(property: :shared, status: :reading) }

  scope :available, -> { where(status: :available) }
  scope :reading, -> { where(status: :reading) }
  scope :losted, -> { where(status: :losted) }
end
