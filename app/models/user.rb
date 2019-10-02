class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :owning_books, class_name: 'PrintBook', foreign_key: 'owner_id'
  has_many :holding_books, class_name: 'PrintBook', foreign_key: 'holder_id'
  has_many :created_books, class_name: 'PrintBook', foreign_key: 'created_by'

  has_many :sponsored_deals, class_name: 'Deal', foreign_key: 'sponsor_id'
  has_many :received_deals, class_name: 'Deal', foreign_key: 'receiver_id'
  has_many :applied_deals, class_name: 'Deal', foreign_key: 'appicant_id'
end
