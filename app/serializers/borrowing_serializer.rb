# frozen_string_literal: true

class BorrowingSerializer < ActiveModel::Serializer
  attributes :id, :status, :print_book_id, :book_id, :holder_id,
             :receiver_id, :status
  belongs_to :receiver, serializer: UserSerializer
  belongs_to :holder, serializer: UserSerializer
  belongs_to :book, serializer: BookSerializer
end
