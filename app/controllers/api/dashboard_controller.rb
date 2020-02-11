# frozen_string_literal: true

class Api::DashboardController < Api::BaseController
  def index
    if stale?(last_modified: Sharing.last.updated_at)
      todos = []
      applies = []

      holder_sharings = Sharing.holder_todo(current_user.id)
      # receiver_sharings = Sharing.receiver_todo(current_user.id)

      holder_sharings.each do |sharing|
        todo = { id: sharing.id }
        todo[:title] = sharing.book.title
        todo[:note] = sharing.status
        todos << todo
      end

      # receiver_sharings.each do |sharing|
      #   todo = { id: sharing.id }
      #   todo[:title] = "#{sharing.book.title} - #{sharing.book.author_name}"
      #   todo[:note] = "book holder: #{sharing.holder.nickname} status: #{sharing.status}"
      #   todos << todo
      # end

      apply_sharings = Sharing.current_applied_by(current_user.id)

      apply_sharings.each do |sharing|
        apply = { id: sharing.id }
        apply[:title] = sharing.book.title
        apply[:note] = sharing.status
        applies << apply
      end

      render json: { todo: todos, apply: applies }
    end
  end
end
