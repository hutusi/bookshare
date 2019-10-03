require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  describe "PUT /api/v1/users" do
    let(:user) { create :user }
    let(:identity) { create :identity, user: user }
    let(:session_params) { {openid: identity.uid} }
    let(:uid_params) { {provider: :wechat, uid: identity.uid} }
    let(:valid_params) { {nickname: 'lisa', 'gender': 'female', country: 'China', language: 'en'} }
    let(:valid_params_with_uid) { valid_params.merge(uid_params) }

    let(:other) { create :user }

    context 'not login' do
      it "create user and responses no_content" do
        put "/api/v1/users/#{user.id}", params: valid_params
        expect(response).to have_http_status(302)
      end
    end

    context "modify other's profile" do
      it "create user and responses no_content" do
        put "/api/v1/users/#{other.id}", params: valid_params_with_uid
        expect(response).to have_http_status(403)
      end
    end

    context "modify self's profile" do
      it "create user and responses no_content" do
        put "/api/v1/users/#{user.id}", params: valid_params_with_uid
        expect(response).to have_http_status(200)
        user.reload
        expect(user.nickname).to eq valid_params[:nickname]
      end
    end
  end
end
