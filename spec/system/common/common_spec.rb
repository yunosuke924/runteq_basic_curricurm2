require 'rails_helper'

RSpec.describe '共通系', type: :system do
  context 'ログイン前' do
    before do
      visit root_path
    end
    describe 'ヘッダー' do
      it 'ヘッダーが正しく表示されていること' do
        expect(page).to have_content('ログイン'), 'ヘッダーに「ログイン」というテキストが表示されていません'
      end
    end

    describe 'フッター' do
      it 'フッターが正しく表示されていること' do
        expect(page).to have_content('Copyright'), '「Copyright」というテキストが表示されていません'
      end
    end
  end

  context 'ログイン後' do
    before do
      login_as_general
      visit root_path
    end
    describe 'ヘッダー' do
      it 'ヘッダーが正しく表示されていること', js: true do
        expect(page).to have_content('掲示板'), 'ヘッダーに「掲示板」というテキストが表示されていません'
        click_on('掲示板')
        expect(page).to have_content('掲示板一覧'), 'ヘッダーに「掲示板一覧」というテキストが表示されていません'
        expect(page).to have_content('掲示板作成'), 'ヘッダーに「掲示板作成」というテキストが表示されていません'

        expect(page).to have_content('ブックマーク一覧'), 'ヘッダーに「ブックマーク一覧」というテキストが表示されていません'

        find('#header-profile').click
        expect(page).to have_content('プロフィール'), 'ヘッダーに「プロフィール」というテキストが表示されていません'
        expect(page).to have_content('ログアウト'), 'ヘッダーに「ログアウト」というテキストが表示されていません'
      end
    end
  end
end
