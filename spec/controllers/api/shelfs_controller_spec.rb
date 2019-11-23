# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ShelfsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #summary' do
    let!(:personal_books) { create_list(:print_book, 10, owner: user, property: :personal) }
    let!(:lent_books) { create_list(:print_book, 10, owner: user, property: :borrowable) }
    let!(:shared_books) { create_list(:print_book, 10, owner: user, property: :shared) }
    let!(:borrowed_books) { create_list(:print_book, 5, holder: user, property: :borrowable) }
    let!(:received_books) { create_list(:print_book, 3, holder: user, property: :shared) }

    it 'returns print_books list' do
      get :summary
      expect(response.status).to eq 200
      expect(json_response_body['personal'].size).to eq 7
      expect(json_response_body['borrowed'].size).to eq 5
      expect(json_response_body['received'].size).to eq 3

      expect(json_response_body['personal'].first['id']).to eq personal_books.last.id
      expect(json_response_body['lent'].first['id']).to eq lent_books.last.id
      expect(json_response_body['shared'].first['id']).to eq shared_books.last.id
      expect(json_response_body['borrowed'].first['id']).to eq borrowed_books.last.id
      expect(json_response_body['received'].first['id']).to eq received_books.last.id
    end
  end

  describe 'GET #shared' do
    let!(:shared_books) { create_list(:print_book, 10, owner: user, property: :shared) }

    it 'returns print_books list' do
      get :shared
      expect(response.status).to eq 200
      expect(json_response_body['print_books'].first['id']).to eq shared_books.last.id
    end
  end

  describe 'GET #lent' do
    let!(:lent_books) { create_list(:print_book, 10, owner: user, property: :borrowable) }

    it 'returns print_books list' do
      get :lent
      expect(response.status).to eq 200
      expect(json_response_body['print_books'].first['id']).to eq lent_books.last.id
    end
  end

  describe 'GET #received' do
    let!(:received_books) { create_list(:print_book, 10, holder: user, property: :shared) }

    it 'returns print_books list' do
      get :received
      expect(response.status).to eq 200
      expect(json_response_body['print_books'].first['id']).to eq received_books.last.id
    end
  end

  describe 'GET #borrowed' do
    let!(:borrowed_books) { create_list(:print_book, 10, holder: user, property: :borrowable) }

    it 'returns print_books list' do
      get :borrowed
      expect(response.status).to eq 200
      expect(json_response_body['print_books'].first['id']).to eq borrowed_books.last.id
    end
  end

  describe 'GET #personal' do
    let!(:personal_books) { create_list(:print_book, 10, owner: user, property: :personal) }

    it 'returns print_books list' do
      get :personal
      expect(response.status).to eq 200
      expect(json_response_body['print_books'].first['id']).to eq personal_books.last.id
    end
  end
end
