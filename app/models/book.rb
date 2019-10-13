# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates :isbn, presence: true
  validates :isbn, uniqueness: true

  class << self
    def create_by_isbn(isbn)
      url = "https://douban.uieee.com/v2/book/isbn/#{isbn}"
      response = Faraday.get url
      p response.status
      p response.body
      json = JSOBN.parse(response.body)&.symbolize_keys
      raise Exception.new("Cannot find douban book. code:#{json[:code]}, msg:#{json[:msg]}") unless response.status == :ok
      
      Book.create title: json[:title], subtitle: json[:subtitle],
        author: json[:author], publisher: json[:publisher],
        intro: json[:summary], isbn: isbn, cover: json[:image],
        douban_id: json[:id], creator_id: current_user
    end
  end
end
