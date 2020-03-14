# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::SharingsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe 'GET #index' do
    context 'no records' do
      it 'returns empty list' do
        get :index
        expect(response.status).to eq 200
        expect(json_data.size).to eq 0
      end
    end

    context 'with records' do
      before do
        create_list(:sharing, 10)
      end

      it 'returns sharings list' do
        get :index
        expect(response.status).to eq 200
        expect(json_data.size).to eq 10
      end
    end
  end

  describe 'GET #show' do
    let(:sharings) { create_list(:sharing, 5) }

    context 'use correct conditions' do
      before { sharings }

      it 'returns the sharing json' do
        get :show, params: { id: sharings.first.id }
        expect(response.status).to eq 200
        expect(json_datum['id']).to eq sharings.first.id
      end
    end
  end

  describe 'POST #create' do
    let(:print_book) { create :print_book, property: :shared }
    let(:post_params) { { print_book_id: print_book.id } }

    context 'use correct conditions' do
      it 'returns the sharing json' do
        post :create, params: post_params
        expect(response.status).to eq 201
        sharing = Sharing.last
        expect(post_params[:print_book_id]).to eq sharing.print_book_id
        expect(sharing.requesting?).to be true
      end
    end

    context 'not shared print book' do
      let(:personal_book) { create :print_book, property: :personal }
      let(:post_params) { { print_book_id: personal_book.id } }

      it 'returns forbidden' do
        post :create, params: post_params
        expect(response.status).to eq 403
      end
    end

    context 'hold the book' do
      let(:print_book) { create :print_book, property: :shared, holder: user }
      let(:post_params) { { print_book_id: print_book.id } }

      it 'returns forbidden' do
        post :create, params: post_params
        expect(response.status).to eq 403
      end
    end

    context 'request a sharing before' do
      before { create :sharing, print_book: print_book, receiver: user }

      it 'returns forbidden' do
        post :create, params: post_params
        expect(response.status).to eq 403
      end
    end

    context 'request a sharing before and finished' do
      before { create :sharing, print_book: print_book, receiver: user, status: :finished }

      it 'returns created' do
        post :create, params: post_params
        expect(response.status).to eq 201
      end
    end
  end

  describe 'POST #accept' do
    let(:receiver) { create :user }
    let(:holder) { user }
    let(:print_book) { create :print_book, holder: holder }
    let(:sharing) do
      create :sharing, print_book: print_book, receiver: receiver,
                       holder: holder, status: :requesting
    end

    context 'with correct status' do
      it 'returns the sharing json' do
        post :accept, params: { id: sharing.id }
        expect(response.status).to eq 201
        sharing.reload
        expect(sharing.accepted?).to be true
      end
    end

    context 'not the holder' do
      let(:holder) { create :user }

      it 'returns forbidden' do
        post :accept, params: { id: sharing.id }
        expect(response.status).to eq 403
      end
    end

    context 'not requesting status' do
      let(:sharing) do
        create :sharing, print_book: print_book, receiver: receiver,
                         holder: holder, status: :lending
      end

      it 'returns forbidden' do
        post :accept, params: { id: sharing.id }
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #reject' do
    let(:receiver) { create :user }
    let(:holder) { user }
    let(:print_book) { create :print_book, holder: holder }
    let(:sharing) do
      create :sharing, print_book: print_book, receiver: receiver,
                       holder: holder, status: :requesting
    end

    context 'with correct status' do
      it 'returns the sharing json' do
        post :reject, params: { id: sharing.id }
        expect(response.status).to eq 201
        sharing.reload
        expect(sharing.rejected?).to be true
      end
    end

    context 'not the holder' do
      let(:holder) { create :user }

      it 'returns forbidden' do
        post :reject, params: { id: sharing.id }
        expect(response.status).to eq 403
      end
    end

    context 'not requesting status' do
      let(:sharing) do
        create :sharing, print_book: print_book, receiver: receiver,
                         holder: holder, status: :lending
      end

      it 'returns forbidden' do
        post :reject, params: { id: sharing.id }
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #lend' do
    let(:receiver) { create :user }
    let(:holder) { user }
    let(:print_book) { create :print_book, holder: holder }
    let(:sharing) do
      create :sharing, print_book: print_book, receiver: receiver,
                       holder: holder, status: :accepted
    end

    context 'with correct status' do
      it 'returns the sharing json' do
        post :lend, params: { id: sharing.id }
        expect(response.status).to eq 201
        sharing.reload
        expect(sharing.lending?).to be true
      end
    end

    context 'not the holder' do
      let(:holder) { create :user }

      it 'returns forbidden' do
        post :lend, params: { id: sharing.id }
        expect(response.status).to eq 403
      end
    end

    context 'not accepted status' do
      let(:sharing) do
        create :sharing, print_book: print_book, receiver: receiver,
                         holder: holder, status: :lending
      end

      it 'returns forbidden' do
        post :lend, params: { id: sharing.id }
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #borrow' do
    let(:receiver) { user }
    let(:holder) { create :user }
    let(:print_book) { create :print_book, holder: holder }
    let(:sharing) do
      create :sharing, print_book: print_book, receiver: receiver,
                       holder: holder, status: :lending
    end

    context 'with correct status' do
      it 'returns the sharing json' do
        post :borrow, params: { id: sharing.id }
        expect(response.status).to eq 201
        sharing.reload
        expect(sharing.borrowing?).to be true
      end
    end

    context 'second sharing' do
    end

    context 'not the receiver' do
      let(:receiver) { create :user }

      it 'returns forbidden' do
        post :borrow, params: { id: sharing.id }
        expect(response.status).to eq 403
      end
    end

    context 'not lending status' do
      let(:sharing) do
        create :sharing, print_book: print_book, receiver: receiver,
                         holder: holder, status: :accepted
      end

      it 'returns forbidden' do
        post :borrow, params: { id: sharing.id }
        expect(response.status).to eq 403
      end
    end
  end

  def json_data
    json_response_body['sharings']
  end

  def json_datum
    json_response_body['sharing']
  end
end
