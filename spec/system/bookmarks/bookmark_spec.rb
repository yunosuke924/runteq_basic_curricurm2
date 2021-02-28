require 'rails_helper'

RSpec.describe 'ブックマーク', type: :system do
  let(:user) { create(:user) }
  let(:board) { create(:board, user: user) }
  before { board }

  it 'ブックマークができること', js: true do
    login_as_general
    visit '/boards'
    find("#js-bookmark-button-for-board-#{board.id}").click
    # ボタンが切り替わること
    expect(page).to have_css("#js-bookmark-button-for-board-#{board.id}[data-method='delete']"), 'ブックマークボタンを押した後にボタンが切り替わっていません'
  end

  it 'ブックマークを外せること', js: true do
    login_as_general
    visit '/boards'
    # ブックマークする
    find("#js-bookmark-button-for-board-#{board.id}").click
    # ブックマークを外す
    find("#js-bookmark-button-for-board-#{board.id}").click
    # ボタンが切り替わること
    expect(page).to have_css("#js-bookmark-button-for-board-#{board.id}[data-method='post']"), 'ブックマークを解除した後にボタンが切り替わっていません'
  end
end
