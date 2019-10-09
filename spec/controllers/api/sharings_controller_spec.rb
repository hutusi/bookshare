# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::SharingsController, type: :controller do
  let(:user) { create :user }
  before { sign_in user }

  describe 'GET #index' do
    context 'no records' do
      it 'should return empty list' do
        get :index
        expect(response.status).to eq 200
        expect(json_response_body['total']).to eq 0
      end
    end

    context 'with records' do
      before do
        create_list(:sharing, 10)
      end

      it 'should return sharings list' do
        get :index
        expect(response.status).to eq 200
        expect(json_response_body['total']).to eq 10
      end
    end
  end

  describe 'GET #show' do
    let(:sharings) { create_list(:sharing, 5) }

    context 'use correct conditions' do
      before { sharings }
      it 'should return the sharing json' do
        get :show, params: { id: sharings.first.id }
        expect(response.status).to eq 200
        expect(json_response_body['id']).to eq sharings.first.id
      end
    end
  end

  describe 'POST #create' do
    let(:print_book) { create :print_book }
    # let(:valid_attributes) { attributes_for :sharing, print_book_id: print_book.id, book_id: print_book.book_id }
    let(:valid_attributes) { { print_book_id: print_book.id, location: 'Shanghai' } }

    context 'use correct conditions' do
      it 'should return the sharing json' do
        post :create, params: valid_attributes
        expect(response.status).to eq 201
        expect(valid_attributes[:print_book_id]).to eq Sharing.last.print_book_id
      end
    end
  end

  describe 'POST #create_request' do
    let(:sharing) { create :sharing }

    context 'with correct status' do
      it 'should return the sharing json' do
        post :create_request, params: { id: sharing.id }
        expect(response.status).to eq 201
        sharing.reload
        expect(sharing.requesting?).to be true
      end
    end
  end

  describe 'POST #create_share' do
    let(:applicant) { create :user }
    let(:print_book) { create :print_book, holder: user }
    let(:sharing) do
      create :sharing, print_book: print_book,
                       applicant: applicant, status: :requesting
    end

    context 'with correct status' do
      it 'should return the sharing json' do
        post :create_share, params: { id: sharing.id }
        expect(response.status).to eq 201
        sharing.reload
        expect(sharing.lending?).to be true
      end
    end
  end

  describe 'POST #create_reject' do
    let(:applicant) { create :user }
    let(:print_book) { create :print_book, holder: user }
    let(:sharing) do
      create :sharing, print_book: print_book,
                       applicant: applicant, status: :requesting
    end

    context 'with correct status' do
      it 'should return the sharing json' do
        post :create_reject, params: { id: sharing.id }
        expect(response.status).to eq 201
        sharing.reload
        expect(sharing.applicant).to be nil
        expect(sharing.available?).to be true
      end
    end
  end

  describe 'DELETE #destroy_share' do
    let(:applicant) { create :user }
    let(:print_book) { create :print_book, holder: user }
    let(:sharing) do
      create :sharing, print_book: print_book,
                       applicant: applicant, status: :lending
    end

    context 'with correct status' do
      it 'should return the sharing json' do
        delete :destroy_share, params: { id: sharing.id }
        expect(response.status).to eq 200
        sharing.reload
        expect(sharing.requesting?).to be true
      end
    end
  end

  describe 'POST #create_accept' do
    let(:applicant) { user }
    let(:holder) { create :user }
    let(:print_book) { create :print_book, holder: holder }
    let(:sharing) do
      create :sharing, print_book: print_book,
                       applicant: applicant, status: :lending
    end

    context 'with correct status' do
      it 'should return the sharing json' do
        post :create_accept, params: { id: sharing.id }
        expect(response.status).to eq 201
        sharing.reload
        expect(sharing.borrowing?).to be true
      end
    end

    context 'second sharing' do
    end
  end
end
