# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ShelfsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #summary' do
    let!(:personal_books) do
      create_list(:print_book, 10, owner: user,
                                   property: :personal)
    end
    let!(:lent_books) do
      create_list(:print_book, 10, owner: user,
                                   property: :borrowable)
    end
    let!(:shared_books) do
      create_list(:print_book, 10, owner: user,
                                   property: :shared)
    end
    let!(:borrowed_books) do
      create_list(:print_book, 5, holder: user,
                                  property: :borrowable)
    end
    let!(:received_books) do
      create_list(:print_book, 3, holder: user,
                                  property: :shared)
    end

    it 'returns print_books list' do
      get :summary
      expect(response.status).to eq 200
      expect(jsonr['personal'].size).to eq 7
      expect(jsonr['borrowed'].size).to eq 5
      expect(jsonr['received'].size).to eq 3

      expect(jsonr['personal'].first['id']).to eq personal_books.last.id
      expect(jsonr['lent'].first['id']).to eq lent_books.last.id
      expect(jsonr['shared'].first['id']).to eq shared_books.last.id
      expect(jsonr['borrowed'].first['id']).to eq borrowed_books.last.id
      expect(jsonr['received'].first['id']).to eq received_books.last.id
    end
  end

  describe 'GET #shared' do
    let!(:shared_books) do
      create_list(:print_book, 10, owner: user, property: :shared)
    end

    it 'returns print_books list' do
      get :shared
      expect(response.status).to eq 200
      expect(jsonr['print_books'].first['id']).to eq shared_books.last.id
    end
  end

  describe 'GET #lent' do
    let!(:lent_books) do
      create_list(:print_book, 10, owner: user, property: :borrowable)
    end

    it 'returns print_books list' do
      get :lent
      expect(response.status).to eq 200
      expect(jsonr['print_books'].first['id']).to eq lent_books.last.id
    end
  end

  describe 'GET #received' do
    let!(:received_books) do
      create_list(:print_book, 10, holder: user,
                                   property: :shared)
    end

    it 'returns print_books list' do
      get :received
      expect(response.status).to eq 200
      expect(jsonr['print_books'].first['id']).to eq received_books.last.id
    end
  end

  describe 'GET #borrowed' do
    let!(:borrowed_books) do
      create_list(:print_book, 10, holder: user, property: :borrowable)
    end

    it 'returns print_books list' do
      get :borrowed
      expect(response.status).to eq 200
      expect(jsonr['print_books'].first['id']).to eq borrowed_books.last.id
    end
  end

  describe 'GET #personal' do
    let!(:personal_books) do
      create_list(:print_book, 10, owner: user, property: :personal)
    end

    it 'returns print_books list' do
      get :personal
      expect(response.status).to eq 200
      expect(jsonr['print_books'].first['id']).to eq personal_books.last.id
    end
  end

  def jsonr
    json_response_body
  end
end
