# frozen_string_literal: true

class Book < ApplicationRecord
  acts_as_taggable

  enum data_source: { seed: 0, admin: 20, douban: 60, ugc: 90 }

  has_many :print_books, dependent: :restrict_with_exception

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :author, class_name: 'Author', foreign_key: 'author_id', optional: true
  belongs_to :translator, class_name: 'Translator', foreign_key: 'translator_id', optional: true
  belongs_to :publisher, optional: true
  belongs_to :series, optional: true

  validates :isbn, presence: true
  validates :isbn, uniqueness: true

  class << self
    def create_by_isbn(isbn, creator)
      json = FetchDoubanBookService.new(isbn).execute

      author_name = json['author']&.first
      author = Author.find_by(name: author_name)
      author = Author.create(name: author_name, intro: json['author_intro']) if author.blank?

      translator_name = json['translator']&.first
      translator = Translator.find_or_create_by(name: translator_name)
      publisher = Publisher.find_or_create_by(name: json['publisher'])

      series = Series.find_by(douban_id: json.dig('series', 'id'))
      if series.blank?
        series = Series.create(name: json.dig('series', 'title'),
                               douban_id: json.dig('series', 'id'))
      end

      # puts json['pubdate']
      isbn = json['isbn13'] || json['isbn10'] || isbn
      book = Book.create title: json['title'], subtitle: json['subtitle'],
                  isbn10: json['isbn10'], isbn13: json['isbn13'],
                  origin_title: json['origin_title'], alt_title: json['alt_title'],
                  image: json['image'], images: json['images'], # JSON.parse(json['images']),
                  author_name: author&.name, author_id: author&.id,
                  translator_name: translator&.name, translator_id: translator&.id,
                  publisher_name: publisher&.name, publisher_id: publisher&.id,
                  pubdate: json['pubdate']&.try_to_datetime,
                  rating: json['rating'], # JSON.parse(json['rating']),
                  binding: json['binding'], price: json['price'], pages: json['pages'],
                  series_id: series&.id, series_name: series&.name,
                  summary: json['summary'], catalog: json['catalog'],
                  cover: json['image'], douban_id: json['id'],
                  isbn: isbn, data_source: :douban, creator_id: creator&.id

      douban_tags = json['tags']
      douban_tags&.each do |tag|
        book.tag_list.add(tag['name']) if tag['name'].present?
        book.save
      end

      book
    end
  end
end
