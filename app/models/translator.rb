# frozen_string_literal: true

class Translator < Litterateur
  has_many :books, dependent: :restrict_with_exception
end
