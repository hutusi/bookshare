# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe "Api::Sessions", type: :request do
  describe "POST /api/v1/sessions/wechat" do
    let(:stub_ok) do
      wechat_res = { openid: 'openid123', session_key: 'sk123',
                     errcode: 0, errmsg: '' }
      stub_request(:get, /api.weixin.qq.com/)
        .to_return(body: wechat_res.to_json, status: 200)
    end

    let(:stub_fail) do
      wechat_res = { openid: 'openid123', session_key: 'sk123',
                     errcode: 40029, errmsg: 'code 无效' }
      stub_request(:get, /api.weixin.qq.com/)
        .to_return(body: wechat_res.to_json, status: 200)
    end

    context 'when user not exists' do
      let(:valid_params) { { js_code: '123456' } }

      it "create user and responses no_content" do
        stub_ok
        post '/api/v1/sessions/wechat', params: valid_params
        expect(response).to have_http_status(:created)
      end
    end

    context 'when user exists' do
      let(:user) { create :user }
      let(:valid_params) { { js_code: '123456' } }

      before do
        create :identity, user: user, provider: 'wechat',
                          uid: 'openid123'
      end

      it "responses created" do
        stub_ok
        post '/api/v1/sessions/wechat', params: valid_params
        expect(response).to have_http_status(:created)
        expect(json_response_body['user_id']).to eq user.id
      end
    end

    context 'when wechat login failed' do
      let(:user) { create :user }
      let(:valid_params) { { js_code: '123456' } }

      before do
        create :identity, user: user, provider: 'wechat',
                          uid: 'openid123'
      end

      it "responses created" do
        stub_fail
        post '/api/v1/sessions/wechat', params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
