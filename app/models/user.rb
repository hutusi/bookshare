class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :identities
  has_many :owning_books, class_name: 'PrintBook', foreign_key: 'owner_id'
  has_many :holding_books, class_name: 'PrintBook', foreign_key: 'holder_id'
  has_many :created_books, class_name: 'PrintBook', foreign_key: 'created_by'

  has_many :sponsored_deals, class_name: 'Deal', foreign_key: 'sponsor_id'
  has_many :received_deals, class_name: 'Deal', foreign_key: 'receiver_id'
  has_many :applied_deals, class_name: 'Deal', foreign_key: 'appicant_id'

  def self.create_by_wechat(params)
    ActiveRecord::Base.transaction do
      fake_email = "johndoe-#{(User.last&.id.presence || 0 ) + 1}@fake-for-bookshare.com"
      user = User.new(
        email: params[:email].presence || fake_email,
        password: Devise.friendly_token[0,20]
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
end
