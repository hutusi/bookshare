require 'rails_helper'

RSpec.describe Api::DealsController, type: :controller do
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
        create_list(:deal, 10)
      }

      it 'should return deals list' do
        get :index
        expect(response.status).to eq 200
        expect(json_response_body['total']).to eq 10
      end
    end
  end

  describe 'GET #show' do
    login_user
    let(:deals) { create_list(:deal, 5) } 
    
    context 'use correct conditions' do
      before { deals }
      it 'should return the deal json' do
        get :show, params: { id: deals.first.id }
        expect(response.status).to eq 200
        expect(json_response_body['id']).to eq deals.first.id
      end
    end
  end

  describe 'POST #create' do
    login_user
    let(:print_book) { create :print_book }
    # let(:valid_attributes) { attributes_for :deal, print_book_id: print_book.id, book_id: print_book.book_id }
    let(:valid_attributes) { { type: 'Borrowing', print_book_id: print_book.id, location: 'Shanghai' } }

    context 'use correct conditions' do
      it 'should return the deal json' do
        post :create, params: valid_attributes
        expect(response.status).to eq 201
        deal = Deal.last
        expect(valid_attributes[:print_book_id]).to eq deal.print_book_id
      end
    end
  end
end
