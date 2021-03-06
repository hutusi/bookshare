# frozen_string_literal: true

class PrintBook < ApplicationRecord
  include ActiveModel::Serializers::JSON
  include RegionPresentable

  # personal book is only seen by self, borrowable book is seen by others and
  # can be borrowed.
  # shared book is shared to others.
  enum property: { personal: 0, borrowable: 50, shared: 100 }
  enum status: { available: 0, reading: 55, losted: 99 }

  # == Attributes ===========================================================

  # == Relationships ========================================================
  has_many :sharings, dependent: :restrict_with_exception
  has_many :borrowings, dependent: :restrict_with_exception

  belongs_to :book
  belongs_to :owner, class_name: 'User'
  belongs_to :holder, class_name: 'User'
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id',
                       inverse_of: :created_print_books

  # == Validations ==========================================================
  validates :region_code, numericality: { only_integer: true,
                                          greater_than: 100000,
                                          less_than: 900000 },
                          allow_nil: true
  validates :book_id, uniqueness: { scope: :owner_id }

  # == Scopes ===============================================================
  scope :all_personal, -> { where(property: :personal) }
  scope :all_borrowable, -> { where(property: :borrowable) }
  scope :all_shared, -> { where(property: :shared) }
  scope :available_borrowable,
        lambda {
          where(property: :borrowable, status: :available)
        }
  scope :reading_borrowable,
        lambda {
          where(property: :borrowable, status: :reading)
        }
  scope :available_shared, -> { where(property: :shared, status: :available) }
  scope :reading_shared, -> { where(property: :shared, status: :reading) }

  scope :all_available, -> { where(status: :available) }
  scope :all_reading, -> { where(status: :reading) }
  scope :all_losted, -> { where(status: :losted) }

  scope :by_keyword,
        lambda { |keyword|
          joins(:book)
            .where('books.title like :keyword or books.author_name
 like :keyword or description like :keyword',
                   keyword: "%#{keyword}%")
        }

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
end
