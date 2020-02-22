REDIS_BASE = 'redis://127.0.0.1:6379'
# sidekiq: #{REDIS_BASE}/0
# region cache:
REGION_REDIS_URL = "#{REDIS_BASE}/1"
REGION_REDIS_STORE = ::Redis.new(url: REGION_REDIS_URL)
if (REGION_REDIS_STORE.keys('*')&.empty?)
  region_file = Rails.root.join 'db', 'raw', 'redis', 'region.json'
  if (File.exists? region_file)
    region_json = File.read region_file
    region_hash = JSON.parse region_json
    region_hash.each do |k, v|
      REGION_REDIS_STORE.set(k, v)
    end
  end
end
