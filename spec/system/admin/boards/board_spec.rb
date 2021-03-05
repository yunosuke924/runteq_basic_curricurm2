require 'rails_helper'

RSpec.describe '管理画面/掲示板', type: :system do
  let(:board1) { create(:board, created_at: DateTime.new(2019, 1, 1))}
  let(:board2) { create(:board, created_at: DateTime.new(2019, 1, 2))}
  let(:board3) { create(:board, created_at: DateTime.new(2019, 1, 3))}
  let(:board4) { create(:board, created_at: DateTime.new(2019, 1, 4))}

  before do
    login_as_admin
    board1
    board2
    board3
    board4

    click_on '掲示板一覧'
  end
  
  describe '掲示板一覧' do
    it 'メニューのアクティブ・非アクティブが機能していること' do
      expect(find('.nav-link.active')).to have_content('掲示板一覧'), '掲示板一覧画面にいるときにメニュー「掲示板一覧」がアクティブになっていません'
      expect(find('.nav-link.active')).not_to have_content('ユーザー一覧'), '掲示板一覧画面にいるときにメニュー「ユーザー一覧」が非アクティブになっていません'
    end

    it '掲示板が一覧表示されること' do
      boards = [board1, board2, board3, board4]
      boards.each do |board|
        # withinでスコープを作成して確認した方が良い
        expect(page).to have_content(board.id), '掲示板IDが表示されていません'
        expect(page).to have_content(board.title), '掲示板のタイトルが表示されていません'
        expect(page).to have_content(board.user.decorate.full_name), '掲示板の投稿者のフルネームが表示されていません'
      end
    end

    it 'タイトルでの検索が機能すること' do
      fill_in 'q_title_or_body_cont', with: board1.title
      click_on '検索'
      expect(page).to have_content(board1.title), 'タイトルでの検索が正しく機能していません'
      expect(page).not_to have_content(board2.title), 'タイトルでの検索が正しく機能していません'
      expect(page).not_to have_content(board3.title), 'タイトルでの検索が正しく機能していません'
      expect(page).not_to have_content(board4.title), 'タイトルでの検索が正しく機能していません'
    end

    it '本文での検索が機能すること' do
      fill_in 'q_title_or_body_cont', with: board1.body
      click_on '検索'
      expect(page).to have_content(board1.title), '本文での検索が正しく機能していません'
      expect(page).not_to have_content(board2.title), '本文での検索が正しく機能していません'
      expect(page).not_to have_content(board3.title), '本文での検索が正しく機能していません'
      expect(page).not_to have_content(board4.title), '本文での検索が正しく機能していません'
    end

    it '日付(from)での検索が機能すること' do
      fill_in 'q_created_at_gteq', with: DateTime.new(2019, 1, 2)
      click_on '検索'
      expect(page).to have_content(board2.title), '日付(from)での検索が正しく機能していません'
      expect(page).to have_content(board3.title), '日付(from)での検索が正しく機能していません'
      expect(page).to have_content(board4.title), '日付(from)での検索が正しく機能していません'
      expect(page).not_to have_content(board1.title), '日付(from)での検索が正しく機能していません'
    end

    it '日付(to)での検索が機能すること' do
      fill_in 'q_created_at_lteq_end_of_day', with: DateTime.new(2019, 1, 3)
      click_on '検索'
      expect(page).to have_content(board1.title), '日付(to)での検索が正しく機能していません'
      expect(page).to have_content(board2.title), '日付(to)での検索が正しく機能していません'
      expect(page).to have_content(board3.title), '日付(to)での検索が正しく機能していません'
      expect(page).not_to have_content(board4.title), '日付(to)での検索が正しく機能していません'
    end
  end

  describe '掲示板詳細' do
    it 'メニューのアクティブ・非アクティブが機能していること' do
      expect(find('.nav-link.active')).to have_content('掲示板一覧'), '掲示板詳細画面にいるときにメニュー「掲示板一覧」がアクティブになっていません'
      expect(find('.nav-link.active')).not_to have_content('ユーザー一覧'), '掲示板詳細画面にいるときにメニュー「ユーザー一覧」が非アクティブになっていません'
    end

    it '掲示板の詳細情報が表示されること' do
      click_on board1.title
      expect(current_path).to eq admin_board_path(board1)
      expect(page).to have_content(board1.id), '掲示板IDが表示されていません'
      expect(page).to have_content(board1.title), '掲示板のタイトルが表示されていません'
      expect(page).to have_content(board1.user.decorate.full_name), '掲示板の投稿者のフルネームが表示されていません'
      expect(page).to have_content(board1.body), '掲示板の本文が表示されていません'
    end
  end

  describe '掲示板編集' do
    it 'メニューのアクティブ・非アクティブが機能していること' do
      expect(find('.nav-link.active')).to have_content('掲示板一覧'), '掲示板編集画面にいるときにメニュー「掲示板一覧」がアクティブになっていません'
      expect(find('.nav-link.active')).not_to have_content('ユーザー一覧'), '掲示板編集画面にいるときにメニュー「ユーザー一覧」が非アクティブになっていません'
    end

    it '掲示板を編集できること' do
      visit admin_board_path(board1)
      click_on '編集'
      expect(current_path).to eq edit_admin_board_path(board1)
      fill_in 'タイトル', with: '変更後タイトル'
      fill_in '本文', with: '変更後本文'
      click_on '更新する'
      sleep 1 # 更新処理が完了するまで待機
      expect(current_path).to eq(admin_board_path(board1)), '管理者用の掲示板詳細ページに遷移していません'
      expect(page).to have_content('掲示板を更新しました'), 'フラッシュメッセージ「掲示板を更新しました」が表示されていません'
      expect(page).to have_content('変更後タイトル'), '更新後のタイトルが表示されていません'
      expect(page).to have_content('変更後本文'), '更新後の本文が表示されていません'
    end
  end

  describe '掲示板削除' do
    it '掲示板を削除できること' do
      visit admin_board_path(board1)
      page.accept_confirm { click_on '削除' }
      sleep 1 # 削除処理が完了するまで待機
      expect(current_path).to eq(admin_boards_path), '管理者用の掲示板一覧ページに遷移していません'
      expect(page).to have_content('掲示板を削除しました'), 'フラッシュメッセージ「掲示板を削除しました」が表示されていません'
    end
  end
end
