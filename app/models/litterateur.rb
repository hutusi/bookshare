# frozen_string_literal: true

class Litterateur < ApplicationRecord
  has_many :works, class_name: 'Book', polymorphic: true
end
