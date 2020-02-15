# frozen_string_literal: true

class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :isbn, :cover,
             :douban_id, :creator_id, :created_at,
             :author_name, :translator_name, :publisher_name,
             :pubdate
end
