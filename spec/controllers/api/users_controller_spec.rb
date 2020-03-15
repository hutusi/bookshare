# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #show' do
    let(:users) { create_list(:user, 5) }

    context 'with correct conditions' do
      before { users }

      it 'returns the user info' do
        get :show, params: { id: users.first.id }
        expect(response.status).to eq 200
        expect(json_response_body['user']['id']).to eq users.first.id
        expect(json_response_body['user']).not_to have_key(:api_token)
      end
    end
  end

  describe 'PUT #update' do
    let(:valid_attributes) do
      { nickname: 'New name',
        avatar: 'hello' }
    end

    context 'with correct conditions' do
      it 'update users info' do
        put :update, params: valid_attributes.merge(id: user.id)
        expect(response.status).to eq 200
        user.reload
        expect(user.nickname).to eq valid_attributes[:nickname]
      end
    end

    context 'when update others info' do
      let(:other) { create :user }

      it 'returns forbidden' do
        put :update, params: valid_attributes.merge(id: other.id)
        expect(response.status).to eq 403
      end
    end
  end
end
