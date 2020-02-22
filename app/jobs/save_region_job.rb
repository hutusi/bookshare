# frozen_string_literal: true

class SaveRegionJob < ApplicationJob
  queue_as :default

  def perform(region)
    region_hash = JSON.parse(region)

    province = region_hash['province']
    save_region(province['code'], province['name'])

    city = region_hash['city']
    save_region(city['code'], city['name'])

    district = region_hash['district']
    save_region(district['code'], district['name'])
  end

  private

  def save_region(code, name)
    # puts "#{code} ===> #{name}"
    return if REGION_REDIS_STORE.get(code)

    REGION_REDIS_STORE.set(code, name)

    # save to file
    region_file = Rails.root.join 'db', 'raw', 'redis', 'region.json'
    if File.exist? region_file
      region_json = File.read region_file
      region_hash = JSON.parse region_json
    else
      region_hash = {}
    end

    region_hash[code] = name
    # puts "Save to #{region_file}"
    File.write region_file, region_hash.to_json
  end
end
