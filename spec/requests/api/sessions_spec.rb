# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::Sessions", type: :request do
  describe "POST /api/v1/sessions/wechat" do
    context 'user not exists' do
      let(:valid_params) { {openid: 'xs12345678df'} }
      it "create user and responses no_content" do
        post '/api/v1/sessions/wechat', params: valid_params
        expect(response).to have_http_status(204)
      end
    end

    context 'user exists' do
      let(:user) { create :user }
      let(:identity) { create :identity, user: user }
      let(:valid_params) { {openid: identity.uid} }

      it "responses created" do
        post '/api/v1/sessions/wechat', params: valid_params
        expect(response).to have_http_status(201)
        expect(json_response_body['user_id']).to eq user.id
      end
    end
  end
end
