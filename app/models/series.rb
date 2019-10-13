# frozen_string_literal: true

class Series < ApplicationRecord
  has_many :books, dependent: :restrict_with_exception
end
