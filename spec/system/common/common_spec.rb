require 'rails_helper'

RSpec.describe '共通系', type: :system do
  describe 'ヘッダーフッター' do
    context 'ログイン前' do
      before { visit root_path }
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
      let(:user) { create(:user) }
      before do
        login_as_user(user)
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

  describe 'タイトル' do
    context 'ログイン前画面' do
      describe 'トップページ' do
        it '正しいタイトルが表示されていること' do
          visit root_path
          expect(page).to have_title('RUNTEQ BOARD APP'), 'トップページのタイトルが「RUNTEQ BOARD APP」になっていません'
        end
      end

      describe 'ログインページ' do
        it '正しいタイトルが表示されていること' do
          visit login_path
          expect(page).to have_title('ログイン'), 'ログインページのタイトルに「ログイン」が含まれていません'
        end
      end

      describe 'ユーザー登録ページ' do
        it '正しいタイトルが表示されていること' do
          visit new_user_path
          expect(page).to have_title('ユーザー登録'), 'ユーザー登録ページのタイトルに「ユーザー登録」が含まれていません'
        end
      end
    end

    context 'ログイン後画面' do
      before { login_as_general }
      describe '掲示板作成ページ' do
        it '正しいタイトルが表示されていること' do
          visit new_board_path
          expect(page).to have_title('掲示板作成'), '掲示板作成ページのタイトルに「掲示板作成」が含まれていません'
        end
      end

      describe '掲示板一覧ページ' do
        it '正しいタイトルが表示されていること' do
          visit boards_path
          expect(page).to have_title('掲示板一覧'), '掲示板一覧ページのタイトルに「掲示板一覧」が含まれていません'
        end
      end

      describe '掲示板詳細ページ' do
        it '正しいタイトルが表示されていること' do
          board = create(:board)
          visit board_path(board)
          expect(page).to have_title("#{board.title}"), '掲示板詳細ページのタイトルに「掲示板のタイトル情報」が含まれていません。'
        end
      end

      describe 'プロフィールページ' do
        it '正しいタイトルが表示されていること' do
          visit profile_path
          expect(page).to have_title('プロフィール'), 'プロフィールページのタイトルに「プロフィール」が含まれていません'
        end
      end

      describe 'プロフィール編集ページ' do
        it '正しいタイトルが表示されていること' do
          visit edit_profile_path
          expect(page).to have_title('プロフィール編集'), 'プロフィール編集ページのタイトルに「プロフィール編集」が含まれていません'
        end
      end

      describe 'パスワードリセット申請ページ' do
        it '正しいタイトルが表示されていること' do
          visit new_password_reset_path
          expect(page).to have_title('パスワードリセット申請'), 'パスワードリセット申請ページのタイトルに「パスワードリセット申請」が含まれていません'
        end
      end

      describe 'パスワードリセットページ' do
        it '正しいタイトルが表示されていること' do
          user = create(:user)
          user.generate_reset_password_token!
          visit edit_password_reset_url(user.reset_password_token)
          expect(page).to have_title('パスワードリセット'), 'パスワードリセットページのタイトルに「パスワードリセット」が含まれていません'
        end
      end
    end

    context 'アドミン系画面' do
      context 'ログイン前画面' do
        describe 'ログインページ' do
          it '正しいタイトルが表示されていること' do
            visit admin_login_path
            expect(page).to have_title('管理画面'), '管理画面のログインページのタイトルに「管理画面」が含まれていません'
            expect(page).to have_title('ログイン'), '管理画面のログインページのタイトルに「ログイン」が含まれていません'
          end
        end
      end

      context 'ログイン後画面' do
        before { login_as_admin }
        describe 'ダッシュボード' do
          it '正しいタイトルが表示されていること' do
            visit admin_root_path
            expect(page).to have_title('管理画面'), '管理画面のダッシュボードのタイトルに「管理画面」が含まれていません'
            expect(page).to have_title('ダッシュボード'), '管理画面のダッシュボードのタイトルに「ダッシュボード」が含まれていません'
          end
        end

        describe '掲示板一覧' do
          it '正しいタイトルが表示されていること' do
            visit admin_boards_path
            expect(page).to have_title('掲示板一覧'), '管理画面の掲示板一覧画面のタイトルに「掲示板一覧」が含まれていません'
            expect(page).to have_title('管理画面'), '管理画面の掲示板一覧画面のタイトルに「管理画面」が含まれていません'
          end
        end

        describe '掲示板詳細' do
          it '正しいタイトルが表示されていること' do
            board = create(:board)
            visit admin_board_path(board)
            expect(page).to have_title(board.title), '管理画面の掲示板詳細画面のタイトルに「掲示板のタイトル名」が含まれていません'
            expect(page).to have_title('管理画面'), '管理画面の掲示板詳細画面のタイトルに「管理画面」が含まれていません'
          end
        end

        describe '掲示板編集' do
          it '正しいタイトルが表示されていること' do
            board = create(:board)
            visit edit_admin_board_path(board)
            expect(page).to have_title(board.title), '管理画面の掲示板編集画面のタイトルに「掲示板のタイトル名」が含まれていません'
            expect(page).to have_title('管理画面'), '管理画面の掲示板編集画面のタイトルに「管理画面」が含まれていません'
          end
        end

        describe 'ユーザー一覧' do
          it '正しいタイトルが表示されていること' do
            visit admin_users_path
            expect(page).to have_title('ユーザー一覧'), '管理画面のユーザー一覧画面のタイトルに「ユーザー一覧」が含まれていません'
            expect(page).to have_title('管理画面'), '管理画面のユーザー一覧画面のタイトルに「管理画面」が含まれていません'
          end
        end

        describe 'ユーザー詳細' do
          it '正しいタイトルが表示されていること' do
            user = create(:user)
            visit admin_user_path(user)
            expect(page).to have_title('ユーザー詳細'), '管理画面のユーザー詳細画面のタイトルに「ユーザー詳細」が含まれていません'
            expect(page).to have_title('管理画面'), '管理画面のユーザー詳細画面のタイトルに「管理画面」が含まれていません'
          end
        end

        describe 'ユーザー編集' do
          it '正しいタイトルが表示されていること' do
            user = create(:user)
            visit edit_admin_user_path(user)
            expect(page).to have_title('ユーザー編集'), '管理画面のユーザー編集画面のタイトルに「ユーザー編集」が含まれていません'
            expect(page).to have_title('管理画面'), '管理画面のユーザー編集画面のタイトルに「管理画面」が含まれていません'
          end
        end
      end
    end
  end
end
