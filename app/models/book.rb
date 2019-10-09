# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates :isbn, presence: true
  validates :isbn, uniqueness: true
end
