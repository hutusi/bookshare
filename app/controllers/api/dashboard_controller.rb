# frozen_string_literal: true

class Api::DashboardController < Api::BaseController
  def index
    # if stale?(last_modified: Sharing.last.updated_at)
    approving_sharings = Sharing.holder_todo(current_user.id)
    requesting_sharings = Sharing.current_applied_by(current_user.id)

    approving_borrowings = Borrowing.holder_todo(current_user.id)
    requesting_borrowings = Borrowing.current_applied_by(current_user.id)

    render json: { approving_sharings: s_to_json(approving_sharings),
                   requesting_sharings: s_to_json(requesting_sharings),
                   approving_borrowings: b_to_json(approving_borrowings),
                   requesting_borrowings: b_to_json(requesting_borrowings) }
    # end
  end

  private

  def s_to_json(sharings)
    sharings.map { |x| SharingSerializer.new(x).as_json }
  end

  def b_to_json(borrowings)
    borrowings.map { |x| BorrowingSerializer.new(x).as_json }
  end
end
