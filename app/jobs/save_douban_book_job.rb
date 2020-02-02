# frozen_string_literal: true

require 'zlib'
require 'fileutils'

class SaveDoubanBookJob < ApplicationJob
  queue_as :default

  def perform(isbn, data)
    save_path = Rails.root.join 'db', 'raw', 'douban', 'books'
    # FileUtils.mkdir_p save_path
    # data_compressed = Zlib::Deflate.deflate data
    # File.open(File.join(save_path, isbn), "w:ASCII-8BIT") do |file|
    #   file.write data_compressed
    # end
    File.open(File.join(save_path, isbn), 'w') do |file|
      file.write data
    end
  end
end
