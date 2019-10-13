# frozen_string_literal: true

class Book < ApplicationRecord
  enum data_source: { seed: 0, admin: 20, douban: 60, ugc: 90 }

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :author, class_name: 'Author', foreign_key: 'author_id'
  belongs_to :translator, class_name: 'Translator', foreign_key: 'translator_id'
  belongs_to :publisher

  validates :isbn, presence: true
  validates :isbn, uniqueness: true

  class << self
    def create_by_isbn(isbn)
      url = "https://douban.uieee.com/v2/book/isbn/#{isbn}"
      response = Faraday.get url
      p response.status
      p response.body
      json = JSON.parse(response.body)
      raise Exception, "Cannot find douban book. code:#{json['code']}, msg:#{json['msg']}" unless response.status == :ok

      author = Author.find_or_create_by(name: json['author'])
      author = Author.create(name: json['author'], intro: json['author_intro']) if author.blank?
      translator = Translator.find_or_create_by(name: json['translator'])
      publisher = Publisher.find_or_create_by(name: json['publisher'])

      Book.create title: json['title'], subtitle: json['subtitle'],
                  isbn10: json['isbn10'], isbn13: json['isbn13'],
                  origin_title: json['origin_title'], alt_title: json['alt_title'],
                  image: json['image'], images: JSON.parse(json['images']),
                  author_name: author.name, author_id: author.id,
                  translator_name: translator.name, translator_id: translator.id,
                  publisher_name: publisher.name, publisher_id: publisher.id,
                  pubdate: json['pubdate'].to_datetime,
                  rating: JSON.parse(json['rating']),
                  binding: json['binding'], price: json['price'], pages: json['pages'],
                  summary: json['summary'], catalog: json['catalog'],
                  cover: json[:image], douban_id: json[:id],
                  isbn: isbn, data_source: :douban, creator_id: current_user
    end
  end
end
