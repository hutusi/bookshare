# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :avatar, :gender, :country,
             :province, :city, :language, :region_code, :region
end
