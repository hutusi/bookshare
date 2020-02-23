# frozen_string_literal: true

module RegionPresentable
  include ActiveSupport::Concern

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
