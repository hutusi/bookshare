# frozen_string_literal: true

class PrintBookPreviewSerializer < ActiveModel::Serializer
  attributes :id, :book_id, :property, :status, :description,
             :owner_id, :holder_id, :creator_id
  belongs_to :book, serializer: BookPreviewSerializer
end
