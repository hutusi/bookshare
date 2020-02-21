# frozen_string_literal: true

require 'rails_helper'

RSpec.describe String, lib: true do
  it 'parse date year-month-day to right date' do
    expect('1984-01-05'.try_to_datetime).to eq DateTime.new(1984, 1, 5)
  end

  it 'parse date year-month to right date' do
    expect('1984-01'.try_to_datetime).to eq DateTime.new(1984, 1)
  end

  it 'parse date 1997年2月3日 to right date' do
    expect('1997年2月3日'.try_to_datetime).to eq DateTime.new(1997, 2, 3)
  end

  it 'parse date 1997年2月 to right date' do
    expect('1997年2月'.try_to_datetime).to eq DateTime.new(1997, 2)
  end

  it 'parse date 1997年 to right date' do
    expect('1997年'.try_to_datetime).to eq DateTime.new(1997)
  end

  it 'parse date 2002 to right date' do
    expect('2002'.try_to_datetime).to eq DateTime.new(2002)
  end

  it 'parse date 2007.5 to right date' do
    expect('2007.5'.try_to_datetime).to eq DateTime.new(2007, 5)
  end

  it 'parse date 2007.5.8 to right date' do
    expect('2007.5.8'.try_to_datetime).to eq DateTime.new(2007, 5, 8)
  end

  it 'parse invalid date to nil' do
    expect('hell-nodate-hello'.try_to_datetime).to be_nil
  end

  # It's weird:
  #   DateTime.parse 'nodate-01' ==> Sat, 01 Feb 2020 00:00:00 +0000
  #   DateTime.parse 'hello-nodate-01' ==> Sat, 01 Feb 2020 00:00:00 +0000
  #   DateTime.parse 'nodate-1' ==> ArgumentError (invalid date)
  # it 'parse invalid date to 1900-01-01' do
  #   expect('nodate-01'.try_to_datetime).to be_nil
  # end
end
