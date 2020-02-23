# frozen_string_literal: true

class PrintBookPreviewSerializer < ActiveModel::Serializer
  attributes :id, :book_id, :property, :status, :description,
             :owner_id, :holder_id, :creator_id, :region_code, :region
  belongs_to :book, serializer: BookPreviewSerializer
  belongs_to :owner, serializer: UserSerializer
  belongs_to :holder, serializer: UserSerializer
end
