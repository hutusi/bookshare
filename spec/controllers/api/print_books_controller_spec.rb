# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::PrintBooksController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #index' do
    login_user
    context 'with no records' do
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

    context 'when search no property' do
      it 'returns forbidden' do
        get :index
        expect(response.status).to eq 403
      end
    end
  end

  describe 'GET #for_share' do
    before do
      create_list(:print_book, 10, property: :personal)
      create_list(:print_book, 11, property: :borrowable)
      create_list(:print_book, 15, property: :shared)
    end

    context 'with correct conditions' do
      it 'returns only shared print books' do
        get :for_share
        expect(response.status).to eq 200
        expect(json_data.size).to eq 15
      end
    end
  end

  describe 'GET #for_borrow' do
    before do
      create_list(:print_book, 10, property: :personal)
      create_list(:print_book, 11, property: :borrowable)
      create_list(:print_book, 15, property: :shared)
    end

    context 'with correct conditions' do
      it 'returns only shared print books' do
        get :for_borrow
        expect(response.status).to eq 200
        expect(json_data.size).to eq 11
      end
    end
  end

  describe 'GET #search' do
    before do
      create :print_book, description: 'hello world', owner: user
      create :print_book, description: 'myhellohi', owner: user
      create :print_book, description: 'hi world'
      create :print_book, description: 'hello hello'
      create :print_book, description: 'heli world', property: :shared
    end

    context 'when search personal print books' do
      it 'returns the self owned print books' do
        get :search, params: { property: :personal, keyword: 'hello' }
        expect(response.status).to eq 200
        expect(json_data.size).to eq 2
      end
    end

    context 'when search shared print books' do
      it 'returns the search result' do
        get :search, params: { property: :shared, keyword: 'world' }
        expect(response.status).to eq 200
        expect(json_data.size).to eq 1
      end
    end

    context 'when search no property' do
      it 'returns forbidden' do
        get :search, params: { keyword: 'world' }
        expect(response.status).to eq 403
      end
    end
  end

  describe 'GET #show' do
    let(:print_books) { create_list(:print_book, 5) }

    context 'with correct conditions' do
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
    let(:valid_attributes) { { book_id: book.id, description: 'New book' } }

    context 'with correct conditions' do
      it 'returns the print_book json' do
        post :create, params: valid_attributes
        expect(response.status).to eq 201
        print_book = PrintBook.last
        expect(print_book.book_id).to eq valid_attributes[:book_id]
      end
    end
  end

  describe 'PUT #update' do
    let(:valid_attributes) do
      { description: 'New discription.',
        region_code: '110011' }
    end

    context 'with correct conditions' do
      let(:print_book) { create :print_book, owner: user }

      it 'returns the print_book json' do
        put :update, params: valid_attributes.merge(id: print_book.id)
        expect(response.status).to eq 200
        print_book.reload
        expect(print_book.description).to eq valid_attributes[:description]
      end
    end

    context 'when update shared print book' do
      let(:print_book) { create :print_book, owner: user, property: :shared }

      context 'when applied before' do
        before { create :sharing, print_book_id: print_book.id }

        it 'returns forbidden' do
          put :update, params: valid_attributes.merge(id: print_book.id)
          expect(response.status).to eq 403
        end
      end
    end
  end

  describe 'PUT #update_property' do
    let(:valid_attributes) { { property: :shared } }

    context 'when login_user not same with print_books owner' do
      let!(:print_book) { create :print_book }

      it 'returns forbidden' do
        put :update_property, params: valid_attributes.merge(id: print_book.id)
        expect(response.status).to eq 403
        print_book.reload
        expect(print_book.shared?).to be false
      end
    end

    context 'when login_user same with print_books owner' do
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

    context 'when login_user not same with print_books holder' do
      let!(:print_book) { create :print_book }

      it 'returns forbidden' do
        put :update_status, params: valid_attributes.merge(id: print_book.id)
        expect(response.status).to eq 403
        print_book.reload
        expect(print_book.reading?).to be false
      end
    end

    context 'when login_user same with print_books holder' do
      let!(:print_book) { create :print_book, holder: user }

      it 'returns the print_book json' do
        put :update_status, params: valid_attributes.merge(id: print_book.id)
        expect(response.status).to eq 200
        print_book.reload
        expect(print_book.reading?).to be true
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:print_book) { create :print_book, owner: user, property: :personal }

    context 'with correct conditions' do
      it 'delete the print book' do
        delete :destroy, params: { id: print_book.id }
        expect(response.status).to eq 200
        expect(PrintBook.all.size).to eq 0
      end
    end

    context 'when not the owner' do
      let(:print_book) { create :print_book, property: :personal }

      it 'returns forbidden' do
        delete :destroy, params: { id: print_book.id }
        expect(response.status).to eq 403
      end
    end

    context 'when not personal print book' do
      let(:print_book) { create :print_book, owner: user, property: :shared }

      it 'returns forbidden' do
        delete :destroy, params: { id: print_book.id }
        expect(response.status).to eq 403
      end
    end
  end

  def json_data
    json_response_body['print_books']
  end

  def json_datum
    json_response_body['print_book']
  end
end
