# frozen_string_literal: true

class Sharing < Deal
  include AASM

  #             (request)     (accept request)  (confirm get book)   (next sharing' borrow)
  # available -> requesting ->   lending ->     borrowing         -> finish

  aasm column: :status, enum: true do
    state :available, initial: true
    state :requesting
    state :lending
    state :borrowing
    state :finished

    event :request do
      transitions from: :available, to: :requesting
    end

    event :share do
      transitions from: :requesting, to: :lending
    end

    event :reject do
      transitions from: :requesting, to: :available
    end

    event :revert_share do
      transitions from: :lending, to: :requesting
    end

    event :accept do
      transitions from: :lending, to: :borrowing
    end

    event :finish do
      transitions from: :borrowing, to: :finished
    end
  end
end
