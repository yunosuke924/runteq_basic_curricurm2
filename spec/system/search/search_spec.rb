require 'rails_helper'

RSpec.describe '検索機能', type: :system do
  let(:login_user) { create(:user) }
  let(:board1) { create(:board, title: 'Webエンジニアになるには', body: '日々学習あるのみです') }
  let(:board2) { create(:board, title: 'Rails以外に必要な知識について', body: 'どんなことが必要？') }
  let(:board3) { create(:board, title: 'Web系とSIerの違いについて', body: '自分が昔いたSIerはGitすら使っていなかった...') }
  let(:board4) { create(:board, title: 'RailsとLaravel、どっちがよいか', body: '宗教戦争の話になります。その話をする必要はありません。') }

  describe '掲示板一覧画面での検索' do
    before do
      login_as_general
      board1
      board2
      visit boards_path
    end
    context '検索条件に該当する掲示板がある場合' do
      describe 'タイトルでの検索機能の検証' do
        it '該当する掲示板のみ表示されること' do
          fill_in 'q_title_or_body_cont', with: 'Web'
          click_on '検索'
          expect(current_path).to eq(boards_path), '掲示板一覧でないページに遷移しています'
          expect(page).to have_content(board1.title), '掲示板タイトルでの検索機能が正しく機能していません'
          expect(page).not_to have_content(board2.title), '掲示板タイトルでの検索機能が正しく機能していません'
        end
      end

      describe '本文での検索機能の検証' do
        it '該当する掲示板のみ表示されること' do
          fill_in 'q_title_or_body_cont', with: '必要'
          click_on '検索'
          expect(current_path).to eq(boards_path), '掲示板一覧でないページに遷移しています'
          expect(page).to have_content(board2.title), '掲示板本文での検索機能が正しく機能していません'
          expect(page).not_to have_content(board1.title), '掲示板本文での検索機能が正しく機能していません'
        end
      end
    end

    context '検索条件に該当する掲示板がない場合' do
      it '1件もない旨のメッセージが表示されること' do
        fill_in 'q_title_or_body_cont', with: '一件もヒットしないよ'
        click_on '検索'
        expect(current_path).to eq(boards_path), '掲示板一覧でないページに遷移しています'
        expect(page).to have_content('掲示板がありません'), '1件もヒットしない場合、「掲示板がありません」というメッセージが表示されていません'
      end
    end
  end

  describe 'ブックマーク一覧画面での検索' do
    before do
      login_as_user login_user
      board1
      board2
      board3
      board4
      login_user.bookmarks.create(board: board1)
      login_user.bookmarks.create(board: board4)
      visit bookmarks_boards_path
    end
    context '検索条件に該当する掲示板がある場合' do
      describe 'タイトルでの検索機能の検証' do
        it '該当する掲示板のみ表示されること' do
          fill_in 'q_title_or_body_cont', with: 'Web'
          click_on '検索'
          expect(current_path).to eq(bookmarks_boards_path), 'ブックマーク一覧でないページに遷移しています'
          expect(page).to have_content(board1.title), '掲示板タイトルでの検索機能が正しく機能していません'
          expect(page).not_to have_content(board2.title), '掲示板タイトルでの検索機能が正しく機能していません'
          expect(page).not_to have_content(board3.title), '掲示板タイトルでの検索機能が正しく機能していません'
          expect(page).not_to have_content(board4.title), '掲示板タイトルでの検索機能が正しく機能していません'
        end
      end

      describe '本文での検索機能の検証' do
        it '該当する掲示板のみ表示されること' do
          fill_in 'q_title_or_body_cont', with: '必要'
          click_on '検索'
          expect(current_path).to eq(bookmarks_boards_path), 'ブックマーク一覧でないページに遷移しています'
          expect(page).to have_content(board4.title), '掲示板本文での検索機能が正しく機能していません'
          expect(page).not_to have_content(board1.title), '掲示板本文での検索機能が正しく機能していません'
          expect(page).not_to have_content(board2.title), '掲示板本文での検索機能が正しく機能していません'
          expect(page).not_to have_content(board3.title), '掲示板本文での検索機能が正しく機能していません'
        end
      end
    end

    context '検索条件に該当する掲示板がない場合' do
      it '1件もない旨のメッセージが表示されること' do
        visit bookmarks_boards_path
        fill_in 'q_title_or_body_cont', with: '一件もヒットしないよ'
        click_on '検索'
        expect(current_path).to eq(bookmarks_boards_path), 'ブックマーク一覧でないページに遷移しています'
        expect(page).to have_content('ブックマーク中の掲示板がありません'), '1件もヒットしない場合、「ブックマーク中の掲示板がありません」というメッセージが表示されていません'
      end
    end
  end
end
