# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::BorrowingsController, type: :controller do
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
        create_list(:borrowing, 10)
      end

      it 'returns borrowings list' do
        get :index
        expect(response.status).to eq 200
        expect(json_data.size).to eq 10
      end
    end
  end

  describe 'GET #show' do
    let(:borrowings) { create_list(:borrowing, 5) }

    context 'with correct conditions' do
      before { borrowings }

      it 'returns the borrowing json' do
        get :show, params: { id: borrowings.first.id }
        expect(response.status).to eq 200
        expect(json_datum['id']).to eq borrowings.first.id
      end
    end
  end

  describe 'POST #create' do
    let(:print_book) { create :print_book, property: :borrowable }
    # let(:valid_attributes) { attributes_for :borrowing, print_book_id: print_book.id, book_id: print_book.book_id }
    let(:valid_attributes) { { print_book_id: print_book.id } }

    context 'with correct conditions' do
      it 'returns the borrowing json' do
        post :create, params: valid_attributes
        expect(response.status).to eq 201
        borrowing = Borrowing.last
        expect(valid_attributes[:print_book_id]).to eq borrowing.print_book_id
        expect(borrowing.requesting?).to be true
      end
    end
  end

  describe 'POST #accept' do
    let(:receiver) { create :user }
    let(:holder) { user }
    let(:print_book) { create :print_book, holder: holder }
    let(:borrowing) do
      create :borrowing, print_book: print_book, receiver: receiver, holder: holder, status: :requesting
    end

    context 'with correct status' do
      it 'returns the borrowing json' do
        post :accept, params: { id: borrowing.id }
        expect(response.status).to eq 201
        borrowing.reload
        expect(borrowing.accepted?).to be true
      end
    end
  end

  describe 'POST #reject' do
    let(:receiver) { create :user }
    let(:holder) { user }
    let(:print_book) { create :print_book, holder: holder }
    let(:borrowing) do
      create :borrowing, print_book: print_book, receiver: receiver, holder: holder, status: :requesting
    end

    context 'with correct status' do
      it 'returns the borrowing json' do
        post :reject, params: { id: borrowing.id }
        expect(response.status).to eq 201
        borrowing.reload
        expect(borrowing.rejected?).to be true
      end
    end
  end

  describe 'POST #lend' do
    let(:receiver) { create :user }
    let(:holder) { user }
    let(:print_book) { create :print_book, holder: holder }
    let(:borrowing) do
      create :borrowing, print_book: print_book, receiver: receiver, holder: holder, status: :accepted
    end

    context 'with correct status' do
      it 'returns the borrowing json' do
        post :lend, params: { id: borrowing.id }
        expect(response.status).to eq 201
        borrowing.reload
        expect(borrowing.lending?).to be true
      end
    end
  end

  describe 'POST #borrow' do
    let(:receiver) { user }
    let(:holder) { create :user }
    let(:print_book) { create :print_book, holder: holder }
    let(:borrowing) do
      create :borrowing, print_book: print_book, receiver: receiver, holder: holder, status: :lending
    end

    context 'with correct status' do
      it 'returns the borrowing json' do
        post :borrow, params: { id: borrowing.id }
        expect(response.status).to eq 201
        borrowing.reload
        expect(borrowing.borrowing?).to be true
      end
    end
  end

  describe 'POST #return' do
    let(:receiver) { user }
    let(:holder) { create :user }
    let(:print_book) { create :print_book, holder: holder }
    let(:borrowing) do
      create :borrowing, print_book: print_book, receiver: receiver, holder: holder, status: :borrowing
    end

    context 'with correct status' do
      it 'returns the borrowing json' do
        post :return, params: { id: borrowing.id }
        expect(response.status).to eq 201
        borrowing.reload
        expect(borrowing.returning?).to be true
      end
    end
  end

  describe 'POST #finish' do
    let(:receiver) { create :user }
    let(:holder) { user }
    let(:print_book) { create :print_book, holder: holder }
    let(:borrowing) do
      create :borrowing, print_book: print_book, receiver: receiver, holder: holder, status: :returning
    end

    context 'with correct status' do
      it 'returns the borrowing json' do
        post :finish, params: { id: borrowing.id }
        expect(response.status).to eq 201
        borrowing.reload
        expect(borrowing.finished?).to be true
      end
    end
  end

  def json_data
    json_response_body['borrowings']
  end

  def json_datum
    json_response_body['borrowing']
  end
end