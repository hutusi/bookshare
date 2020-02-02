# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::Books", type: :request do
  let(:user) { create :user }

  before { sign_in user }

  describe "GET /api/v1/books" do
    it "responses successful" do
      get '/api/v1/books'
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/v1/books" do
    context "with correct parameters" do
      let(:valid_attributes) { attributes_for :book }

      it "create a book successful" do
        post '/api/v1/books', params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(Book.last.title).to eq valid_attributes[:title]
      end
    end
  end
end
