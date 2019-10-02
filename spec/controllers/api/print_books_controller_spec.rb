require 'rails_helper'

RSpec.describe Api::PrintBooksController, type: :controller do
  describe 'GET #index' do
    login_user
    context 'no records' do
      it 'should return empty list' do
        get :index
        expect(response.status).to eq 200
        expect(json_response_body['total']).to eq 0
      end
    end

    context 'with records' do
      before {
        create_list(:print_book, 10)
      }

      it 'should return print_books list' do
        get :index
        expect(response.status).to eq 200
        expect(json_response_body['total']).to eq 10
      end
    end
  end

  describe 'GET #show' do
    login_user
    let(:print_books) { create_list(:print_book, 5) } 
    
    context 'use correct conditions' do
      before { print_books }
      it 'should return the print_book json' do
        get :show, params: { id: print_books.first.id }
        expect(response.status).to eq 200
        expect(json_response_body['id']).to eq print_books.first.id
      end
    end
  end

  describe 'POST #create' do
    login_user
    let(:book) { create :book }
    let(:valid_attributes) { { book_id: book.id, description: "New book" } }
    
    context 'use correct conditions' do
      it 'should return the print_book json' do
        post :create, params: valid_attributes
        expect(response.status).to eq 201
        print_book = PrintBook.last
        expect(valid_attributes[:book_id]).to eq print_book.book_id
      end
    end
  end
end
