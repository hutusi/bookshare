# frozen_string_literal: true

class PrintBookSerializer < ActiveModel::Serializer
  attributes :id, :book_id, :property, :status, :description,
             :owner_id, :holder_id, :creator_id, :region_code, :region
  belongs_to :book, serializer: BookSerializer
end
