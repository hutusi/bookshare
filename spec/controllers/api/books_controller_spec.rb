# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::BooksController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #index' do
    context 'no records' do
      it 'returns empty list' do
        get :index
        expect(response.status).to eq 200
        expect(json_response_body['total']).to eq 0
      end
    end

    context 'with records' do
      before do
        create_list(:book, 10)
      end

      it 'returns books list' do
        get :index
        expect(response.status).to eq 200
        expect(json_response_body['total']).to eq 10
      end
    end
  end

  describe 'GET #show' do
    let(:books) { create_list(:book, 5) }

    context 'use correct conditions' do
      before { books }

      it 'returns the book json' do
        get :show, params: { id: books.first.id }
        expect(response.status).to eq 200
        expect(json_response_body['id']).to eq books.first.id
      end
    end
  end

  describe 'POST #create' do
    let(:book) { create :book }
    let(:valid_attributes) { attributes_for :book }

    context 'use correct conditions' do
      it 'returns the book json' do
        post :create, params: valid_attributes
        expect(response.status).to eq 201
        book = Book.last
        expect(book.title).to eq valid_attributes[:title]
      end
    end
  end

  describe 'PUT #update' do
    let(:book) { create :book, creator: user }
    let(:valid_attributes) { { title: 'new titile' } }

    context 'use correct conditions' do
      it 'returns the book json' do
        put :update, params: valid_attributes.merge(id: book.id)
        expect(response.status).to eq 200
        book.reload
        expect(book.title).to eq valid_attributes[:title]
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:book) { create :book, creator: user }

    context 'use correct conditions' do
      it 'returns the book json' do
        delete :destroy, params: { id: book.id }
        expect(response.status).to eq 200
        expect(Book.all.size).to eq 0
      end
    end
  end
end
