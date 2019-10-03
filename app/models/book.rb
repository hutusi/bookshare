class Book < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'

  validates_presence_of :isbn
  validates_uniqueness_of :isbn
end
