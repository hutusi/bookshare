# frozen_string_literal: true

class SharingSerializer < ActiveModel::Serializer
  attributes :id, :status, :print_book_id, :book_id, :holder_id,
             :receiver_id, :status
end

class SharingExtSerializer < ActiveModel::Serializer
  attributes :id, :status, :print_book_id, :book_id, :holder_id,
             :receiver_id, :status

  belongs_to :book
  belongs_to :print_book
end
