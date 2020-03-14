# frozen_string_literal: true

class Author < Litterateur
  has_many :books, dependent: :restrict_with_exception
end
