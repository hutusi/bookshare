# frozen_string_literal: true

class Sharing < ApplicationRecord
  include AASM
  include RegionPresentable

  # == Constants ============================================================
  # share status: requesting, lending, borrowing, finished
  enum status: { requesting: 0, accepted: 30, rejected: 40, lending: 60,
                 borrowing: 80, finished: 100, canceled: 999 }

  # 1. (request)  (reject request)
  # requesting ->   rejected

  # 2. (request) (accept request) (lending book) (confirm get book)   (next sharing' borrow)
  # requesting ->  accepted  ->    lending ->     borrowing         -> finish

  aasm column: :status, enum: true do
    # state :initial, initial: true
    state :requesting, initial: true
    state :accepted
    state :rejected
    state :lending
    state :borrowing
    state :finished
    state :canceled

    # event :request do
    #   transitions from: :initial, to: :requesting
    # end

    event :accept do
      transitions from: :requesting, to: :accepted
    end

    event :reject do
      # transitions from: [:requesting, :accepted], to: :rejected
      transitions from: :requesting, to: :rejected
    end

    event :lend do
      transitions from: :accepted, to: :lending
    end

    event :borrow do
      transitions from: :lending, to: :borrowing
    end

    event :finish do
      transitions from: :borrowing, to: :finished
    end

    event :cancel do
      transitions from: [:requesting, :accepted, :rejected, :lending], to: :canceled
    end
  end

  # == Attributes ===========================================================
  # attr_accessor :id, :status

  # == Relationships ========================================================
  belongs_to :print_book
  belongs_to :book, optional: true
  belongs_to :holder, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  # == Validations ==========================================================

  # == Scopes ===============================================================
  scope :holder_todo, ->(user_id) { where(status: [:requesting, :accepted], holder_id: user_id) }
  scope :receiver_todo, ->(user_id) { where(status: [:rejected, :lending], receiver_id: user_id) }
  scope :current_actives, -> { where('status < ?', Sharing.statuses[:finished]) }
  scope :current_applied_by, ->(user_id) { current_actives.where(receiver_id: user_id) }
  scope :current_applied_for, ->(print_book_id) { current_actives.where(print_book_id: print_book_id) }

  # == Callbacks ============================================================
  before_create do
    self.book_id = print_book.book_id
    self.region_code = print_book.region_code
  end

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  def borrow_to(user)
    ActiveRecord::Base.transaction do
      borrow
      rivals = Sharing.current_applied_for(print_book_id).where(receiver_id: user.id)
      rivals.each(&:cancel)

      last_sharing = Sharing.find_by id: print_book.last_deal_id
      last_sharing&.finish
      print_book.update holder_id: receiver.id, last_deal_id: id

      save!
    end
  end
end
