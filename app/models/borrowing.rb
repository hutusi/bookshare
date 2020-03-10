# frozen_string_literal: true

class Borrowing < ApplicationRecord
  include AASM
  include RegionPresentable

  # borrow status: requesting, lending, borrowing, returning, finished
  enum status: { requesting: 0, accepted: 30, rejected: 40, lending: 60,
                 borrowing: 80, returning: 90, finished: 100, canceled: 999 }

  # 1. (request)  (reject request)
  # requesting ->   rejected

  # 2. (request) (accept request) (lending book) (confirm get book) (returning book) (confirm return)
  # requesting ->  accepted  ->    lending ->     borrowing     ->   returning     -> finish

  aasm column: :status, enum: true do
    # state :initial, initial: true
    state :requesting, initial: true
    state :accepted
    state :rejected
    state :lending
    state :borrowing
    state :returning
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

    event :return do
      transitions from: :borrowing, to: :returning
    end

    event :finish do
      transitions from: :returning, to: :finished
    end

    event :cancel do
      transitions from: [:requesting, :accepted, :rejected, :lending], to: :canceled
    end
  end

  # == Attributes ===========================================================

  # == Relationships ========================================================
  belongs_to :print_book
  belongs_to :book, optional: true
  belongs_to :holder, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  # == Validations ==========================================================

  # == Scopes ===============================================================
  scope :holder_todo, ->(user_id) { where(status: [:requesting, :accepted, :returning], holder_id: user_id) }
  scope :receiver_todo, ->(user_id) { where(status: [:rejected, :lending], receiver_id: user_id) }
  scope :current_actives, -> { where('status < ?', Borrowing.statuses[:finished]) }
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
      rivals = Borrowing.current_applied_for(print_book_id).where(receiver_id: user.id)
      rivals.each(&:cancel)
      print_book.update holder_id: receiver.id

      save!
    end
  end

  def return_to(_user)
    ActiveRecord::Base.transaction do
      finish
      print_book.update holder_id: receiver.id

      save!
    end
  end
end
