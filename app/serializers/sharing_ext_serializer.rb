# frozen_string_literal: true

class SharingExtSerializer < ActiveModel::Serializer
  attributes :id, :status, :print_book_id, :book_id, :holder_id,
             :receiver_id, :status, :application_reason, :application_reply,
             :created_at

  belongs_to :book
  belongs_to :print_book
  belongs_to :receiver
end
