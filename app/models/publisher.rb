# frozen_string_literal: true

class Publisher < ApplicationRecord
  has_many :publications, class_name: 'Book'
end
