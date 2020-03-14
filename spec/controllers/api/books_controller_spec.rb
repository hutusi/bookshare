# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Api::BooksController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #index' do
    context 'with no records' do
      it 'returns empty list' do
        get :index
        expect(response.status).to eq 200
        expect(json_data.size).to eq 0
      end
    end

    context 'with records' do
      before do
        create_list(:book, 10)
      end

      it 'returns books list' do
        get :index
        expect(response.status).to eq 200
        expect(json_data.size).to eq 10
      end
    end
  end

  describe 'GET #show' do
    let(:books) { create_list(:book, 5) }

    context 'with correct conditions' do
      before { books }

      it 'returns the book json' do
        get :show, params: { id: books.first.id }
        expect(response.status).to eq 200
        expect(json_datum['id']).to eq books.first.id
      end
    end
  end

  # describe 'POST #create' do
  #   let(:book) { create :book }
  #   let(:valid_attributes) { attributes_for :book }

  #   context 'with correct conditions' do
  #     it 'returns the book json' do
  #       post :create, params: valid_attributes
  #       expect(response.status).to eq 201
  #       book = Book.last
  #       expect(book.title).to eq valid_attributes[:title]
  #     end
  #   end
  # end

  # describe 'PUT #update' do
  #   let(:book) { create :book, creator: user }
  #   let(:valid_attributes) { { title: 'new titile' } }

  #   context 'with correct conditions' do
  #     it 'returns the book json' do
  #       put :update, params: valid_attributes.merge(id: book.id)
  #       expect(response.status).to eq 200
  #       book.reload
  #       expect(book.title).to eq valid_attributes[:title]
  #     end
  #   end
  # end

  # describe 'DELETE #destroy' do
  #   let(:book) { create :book, creator: user }

  #   context 'with correct conditions' do
  #     it 'returns the book json' do
  #       delete :destroy, params: { id: book.id }
  #       expect(response.status).to eq 200
  #       expect(Book.all.size).to eq 0
  #     end
  #   end
  # end

  describe 'GET #isbn' do
    let(:isbn) { '9787505715660' }

    context 'when book exists' do
      let(:book) { create :book, isbn: isbn, isbn13: isbn }

      it 'returns the book json' do
        book
        get :isbn, params: { isbn: book.isbn }
        expect(response.status).to eq 200
        expect(json_datum['id']).to eq book.id
        expect(json_datum['isbn']).to eq isbn
      end
    end

    context 'when book not exists' do
      before do
        book_json = file_fixture("little_prince.json").read
        stub_request(:get, /douban.uieee.com/)
          .to_return(body: book_json, status: 200)
      end

      it 'returns the book json' do
        get :isbn, params: { isbn: isbn }
        expect(response.status).to eq 200
        expect(json_datum['isbn']).to eq isbn
      end
    end

    context 'when book not exists & only book title info' do
      before do
        book_json = file_fixture("book_title.json").read
        stub_request(:get, /douban.uieee.com/)
          .to_return(body: book_json, status: 200)
      end

      it 'returns the book json' do
        get :isbn, params: { isbn: isbn }
        expect(response.status).to eq 200
        expect(json_datum['isbn']).to eq isbn
      end
    end
  end

  def json_data
    json_response_body['books']
  end

  def json_datum
    json_response_body['book']
  end
end
