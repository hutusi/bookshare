# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::DashboardController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #index' do
    context 'with no records' do
      it 'returns ok' do
        get :index
        expect(response.status).to eq 200
      end
    end
  end
end
