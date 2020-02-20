# frozen_string_literal: true

class FetchDoubanBookService
  def initialize(isbn)
    @isbn = isbn
  end

  def execute
    url = "http://douban.uieee.com/v2/book/isbn/#{@isbn}"
    response = Faraday.get url
    json = JSON.parse(response.body)
    unless response.status == 200
      raise Exception, "Cannot find douban book. code:#{json['code']}, \
        msg:#{json['msg']}"
    end

    isbn = json['isbn13'] || json['isbn10'] || @isbn
    SaveDoubanBookJob.perform_later isbn, response.body
    json
  end
end
