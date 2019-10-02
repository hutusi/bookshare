class Sharing < Deal
  include AASM

  aasm column: :status, enum: true do
    state :initial, initial: true
    state :lending
    state :borrowing
    state :finished

    event :share do
      transitions from: :initial, to: :lending
    end

    event :revert_share do
      transitions from: :lending, to: :initial
    end

    event :accept do
      transitions from: :lending, to: :borrowing
    end

    event :finish do
      transitions from: :borrowing, to: :finished
    end
  end
end
