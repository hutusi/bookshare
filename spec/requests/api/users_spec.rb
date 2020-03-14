# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  describe "PUT /api/v1/users" do
    let(:user) { create :user }
    let(:identity) { create :identity, user: user }
    let(:api_token_params) { { api_token: user.api_token } }
    let(:valid_params) do
      { nickname: 'lisa', 'gender': 'female',
        country: 'China', language: 'en' }
    end
    let(:valid_params_with_uid) { valid_params.merge(api_token_params) }

    let(:other) { create :user }

    context 'when not login' do
      it 'create user and responses no_content' do
        put "/api/v1/users/#{user.id}", params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when modify others profile' do
      it 'create user and responses no_content' do
        put "/api/v1/users/#{other.id}", params: valid_params_with_uid
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when  modify self profile' do
      it 'create user and responses no_content' do
        put "/api/v1/users/#{user.id}", params: valid_params_with_uid
        expect(response).to have_http_status(:ok)
        user.reload
        expect(user.nickname).to eq valid_params[:nickname]
      end
    end
  end
end
