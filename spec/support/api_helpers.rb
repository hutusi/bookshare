module ApiHelpers
  def json_response_body
    # JSON.parse(response.body).symbolize_keys
    JSON.parse(response.body)
  end
end

RSpec.configure do |config| 
  config.include ApiHelpers
end
