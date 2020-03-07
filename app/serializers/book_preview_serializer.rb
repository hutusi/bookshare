# frozen_string_literal: true

class BookPreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :intro, :isbn, :cover,
             :douban_id, :creator_id, :created_at, :summary,
             :author_name, :translator_name, :publisher_name,
             :pubdate, :series_name
  has_many :shared_print_books do
    object.print_books.all_shared
  end
  has_many :owned_print_books do
    object.print_books.where(owner_id: scope&.id)
  end
end
