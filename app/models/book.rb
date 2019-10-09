# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates_presence_of :isbn
  validates_uniqueness_of :isbn
end
