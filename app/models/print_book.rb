# frozen_string_literal: true

class PrintBook < ApplicationRecord
  include ActiveModel::Serializers::JSON

  # personal book is only seen by self, borrowable book is seen by others and can be borrowed.
  # shared book is shared to others.
  enum property: { personal: 0, borrowable: 50, shared: 100 }
  enum status: { available: 0, reading: 55, losted: 99 }

  # == Attributes ===========================================================

  # == Relationships ========================================================
  belongs_to :book
  belongs_to :owner, class_name: 'User'
  belongs_to :holder, class_name: 'User'
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  # belongs_to :deal, optional: true
  # belongs_to :last_deal, class_name: 'Deal', optional: true

  # == Validations ==========================================================

  # == Scopes ===============================================================
  scope :all_personal, -> { where(property: :personal) }
  scope :all_borrowable, -> { where(property: :borrowable) }
  scope :all_shared, -> { where(property: :shared) }
  scope :available_borrowable, -> { where(property: :borrowable, status: :available) }
  scope :reading_borrowable, -> { where(property: :borrowable, status: :reading) }
  scope :available_shared, -> { where(property: :shared, status: :available) }
  scope :reading_shared, -> { where(property: :shared, status: :reading) }

  scope :all_available, -> { where(status: :available) }
  scope :all_reading, -> { where(status: :reading) }
  scope :all_losted, -> { where(status: :losted) }

  def region
    if region_code
      province_code = region_code.floor(-4)
      city_code = region_code.floor(-2)
      district_code = region_code

      {
        province: { code: province_code, name: REGION_REDIS_STORE.get(province_code.to_s) },
        city: { code: city_code, name: REGION_REDIS_STORE.get(city_code.to_s) },
        district: { code: district_code, name: REGION_REDIS_STORE.get(district_code.to_s) }
      }
    else
      {}
    end
  end
end
