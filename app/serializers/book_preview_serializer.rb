# frozen_string_literal: true

class BookPreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :intro, :isbn, :cover,
             :douban_id, :creator_id, :created_at, :summary,
             :author_name, :translator_name, :publisher_name,
             :pubdate
end
