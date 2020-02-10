# frozen_string_literal: true

class Sharing < ApplicationRecord
  include AASM

  # share status: requesting, lending, borrowing, finished
  enum status: { requesting: 0, accepted: 30, rejected: 40, lending: 60, borrowing: 80, finished: 100 }

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
  end

  belongs_to :print_book
  belongs_to :book
  belongs_to :holder, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
end
