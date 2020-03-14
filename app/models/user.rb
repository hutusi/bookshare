# frozen_string_literal: true

class User < ApplicationRecord
  include RegionPresentable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum gender: { unknown: 0, male: 1, female: 2 }
  enum language: { en: 0, zh_CN: 1, zh_TW: 2 }

  has_many :identities, dependent: :restrict_with_exception
  has_many :created_books, class_name: 'Book', foreign_key: 'creator_id',
                           dependent: :restrict_with_exception,
                           inverse_of: :creator

  has_many :owning_print_books, class_name: 'PrintBook',
                                foreign_key: 'owner_id',
                                dependent: :restrict_with_exception,
                                inverse_of: :owner
  has_many :holding_print_books, class_name: 'PrintBook',
                                 foreign_key: 'holder_id',
                                 dependent: :restrict_with_exception,
                                 inverse_of: :holder
  has_many :created_print_books, class_name: 'PrintBook',
                                 foreign_key: 'creator_id',
                                 dependent: :restrict_with_exception,
                                 inverse_of: :creator

  validates :username, presence: true
  validates :username, uniqueness: true

  class << self
    def create_by_wechat(params)
      ActiveRecord::Base.transaction do
        fake_username = "johndoe-#{(User.last&.id.presence || 0) + 1}"
        fake_email = "#{fake_username}@fake-for-bookshare.com"

        user = User.new(
          username: params[:username].presence || fake_username,
          email: params[:email].presence || fake_email,
          password: Devise.friendly_token[0, 20],
          api_token: User.generate_api_token
        )
        # user.skip_confirmation!
        user.save!

        identity = Identity.new(
          provider: :wechat,
          uid: params[:openid],
          user: user
        )
        identity.save!

        user
      end
    end

    def generate_api_token
      loop do
        token = SecureRandom.hex
        break token unless User.exists?(api_token: token)
      end
    end
  end
end
