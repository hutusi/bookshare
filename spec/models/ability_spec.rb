# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe "abilities" do
    subject(:ability) { described_class.new(user) }

    let(:user) { create :user }

    context "when reads a book" do
      let(:book) { create :book }

      it { is_expected.to be_able_to(:read, book) }
    end

    context "when creates a book" do
      let(:book) { create :book, creator: user }

      it { is_expected.to be_able_to(:update, book) }
    end

    context "when print_book is shared" do
      let(:print_book) { create :print_book, property: :shared }

      it { is_expected.to be_able_to(:read, print_book) }
    end

    context "when print_book is personal" do
      let(:print_book) { create :print_book, property: :personal }

      it { is_expected.not_to be_able_to(:read, print_book) }
    end

    context "when print_book is personal by self" do
      let(:print_book) { create :print_book, property: :personal, owner: user }

      it { is_expected.to be_able_to(:read, print_book) }
    end

    context "when owns a print_book" do
      let(:print_book) { create :print_book, owner: user }

      it { is_expected.to be_able_to(:manage, print_book) }
    end

    context "when holds a print_book" do
      let(:print_book) { create :print_book, holder: user }

      it { is_expected.to be_able_to(:update, print_book) }
    end

    context "when holds a print_book" do
      let(:print_book) { create :print_book, holder: user }

      it { is_expected.not_to be_able_to(:destroy, print_book) }
    end

    context "when print_book is shared" do
      let(:print_book) { create :print_book, property: :shared }

      it { is_expected.to be_able_to(:read, print_book) }
    end
  end
end
