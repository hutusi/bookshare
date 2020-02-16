# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::PrintBooksController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #index' do
    login_user
    context 'no records' do
      it 'returns empty list' do
        get :index, params: { property: :shared }
        expect(response.status).to eq 200
        expect(json_data.size).to eq 0
      end
    end

    context 'with records' do
      before do
        create_list(:print_book, 10, property: :borrowable)
      end

      it 'returns print_books list' do
        get :index, params: { property: :borrowable }
        expect(response.status).to eq 200
        expect(json_data.size).to eq 10
      end
    end
  end

  describe 'GET #show' do
    let(:print_books) { create_list(:print_book, 5) }

    context 'use correct conditions' do
      before { print_books }

      it 'returns the print_book json' do
        get :show, params: { id: print_books.first.id }
        expect(response.status).to eq 200
        expect(json_datum['id']).to eq print_books.first.id
      end
    end
  end

  describe 'POST #create' do
    let(:book) { create :book }
    let(:valid_attributes) { { book_id: book.id, description: "New book" } }

    context 'use correct conditions' do
      it 'returns the print_book json' do
        post :create, params: valid_attributes
        expect(response.status).to eq 201
        print_book = PrintBook.last
        expect(print_book.book_id).to eq valid_attributes[:book_id]
      end
    end
  end

  describe 'PUT #update' do
    let(:print_book) { create :print_book, owner: user }
    let(:valid_attributes) { { description: "New discription." } }

    context 'use correct conditions' do
      it 'returns the print_book json' do
        put :update, params: valid_attributes.merge(id: print_book.id)
        expect(response.status).to eq 200
        print_book.reload
        expect(print_book.description).to eq valid_attributes[:description]
      end
    end
  end

  describe 'PUT #update_property' do
    let(:valid_attributes) { { property: :shared } }

    context 'login_user not same with print_books owner' do
      let!(:print_book) { create :print_book }

      it 'returns the print_book json' do
        put :update_property, params: valid_attributes.merge(id: print_book.id)
        expect(response.status).to eq 403
        print_book.reload
        expect(print_book.shared?).to be false
      end
    end

    context 'login_user same with print_books owner' do
      let!(:print_book) { create :print_book, owner: user }

      it 'returns the print_book json' do
        put :update_property, params: valid_attributes.merge(id: print_book.id)
        expect(response.status).to eq 200
        print_book.reload
        expect(print_book.shared?).to be true
      end
    end
  end

  describe 'PUT #update_status' do
    let(:valid_attributes) { { status: :reading } }

    context 'login_user not same with print_books holder' do
      let!(:print_book) { create :print_book }

      it 'returns the print_book json' do
        put :update_property, params: valid_attributes.merge(id: print_book.id)
        expect(response.status).to eq 403
        print_book.reload
        expect(print_book.reading?).to be false
      end
    end

    # context 'login_user same with print_books holder' do
    #   let!(:print_book) { create :print_book, holder: user }
    #   it 'should return the print_book json' do
    #     put :update_property, params: valid_attributes.merge(id: print_book.id)
    #     expect(response.status).to eq 200
    #     print_book.reload
    #     expect(print_book.reading?).to be true
    #   end
    # end
  end

  def json_data
    json_response_body['print_books']
  end

  def json_datum
    json_response_body['print_book']
  end
end
