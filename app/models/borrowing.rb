# frozen_string_literal: true

class Borrowing < Deal
  include AASM

  aasm column: :status, enum: true do
    state :initial, initial: true
    state :lending
    state :borrowing
    state :returning
    state :finished

    event :lend do
      transitions from: :initial, to: :lending
    end

    event :revert_lend do
      transitions from: :lending, to: :initial
    end

    event :borrow do
      transitions from: :lending, to: :borrowing
    end

    event :return do
      transitions from: :borrowing, to: :returning
    end

    event :revert_return do
      transitions from: :returning, to: :borrowing
    end

    event :confirm do
      transitions from: :returning, to: :finished
    end
  end
end
