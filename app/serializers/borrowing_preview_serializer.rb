# frozen_string_literal: true

class BorrowingPreviewSerializer < ActiveModel::Serializer
  attributes :id, :status, :print_book_id, :book_id, :holder_id,
             :receiver_id, :status, :application_reason, :application_reply,
             :created_at, :region_code, :region

  belongs_to :book, serializer: BookSerializer
  belongs_to :print_book, serializer: PrintBookSerializer
  belongs_to :receiver, serializer: UserSerializer
  belongs_to :holder, serializer: UserSerializer
end
