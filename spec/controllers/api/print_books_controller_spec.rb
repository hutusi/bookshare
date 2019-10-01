require 'rails_helper'

RSpec.describe Api::PrintBooksController, type: :controller do
  describe 'GET #index' do
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
end
