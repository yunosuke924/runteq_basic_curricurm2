require 'rails_helper'

RSpec.describe '管理画面/ユーザー', type: :system do
  let(:general1) { create(:user, :general, first_name: 'ジェネラル子1', created_at: DateTime.new(2019, 1, 1))}
  let(:general2) { create(:user, :general, first_name: 'ジェネラル子2', created_at: DateTime.new(2019, 1, 2))}
  let(:general3) { create(:user, :general, first_name: 'ジェネラル子3', created_at: DateTime.new(2019, 1, 3))}
  let(:admin) { create(:user, :admin, first_name: 'アドミン子', created_at: DateTime.new(2019, 1, 4))}

  before do
    login_as_admin
    general1
    general2
    general3
    admin

    click_on 'ユーザー一覧'
  end

  describe 'ユーザー一覧' do
    it 'メニューのアクティブ・非アクティブが機能していること' do
      expect(find('.nav-link.active')).to have_content('ユーザー一覧'), 'ユーザー一覧ページにいるときにメニュー「ユーザー一覧」がアクティブになっていません'
      expect(find('.nav-link.active')).not_to have_content('掲示板一覧'), 'ユーザー一覧ページにいるときにメニュー「掲示板一覧」が非アクティブになっていません'
    end

    it 'ユーザーが一覧表示されること' do
      users = [general1, general2, general3, admin]
      users.each do |user|
        # withinでスコープを切った方がより良い実装
        expect(page).to have_content(user.id), 'ユーザーIDが表示されていません'
        expect(page).to have_content(user.decorate.full_name), 'ユーザーのフルネームが表示されていません'
        expect(page).to have_content(user.role_i18n), 'ユーザーの権限が表示されていません'
      end
    end

    it '名前での検索が機能すること' do
      # 各ユーザーの名前を指定してFactoryをcreateした方がより正確
      fill_in 'q_first_name_or_last_name_cont', with: general1.first_name
      click_on '検索'
      expect(page).to have_content(general1.id), 'ユーザー名での検索が正しく機能していません'
    end

    it '権限での検索が機能すること' do
      # 各ユーザーの名前を指定してFactoryをcreateした方がより正確
      select '管理者', from: 'q_role_eq'
      click_on '検索'
      expect(page).to have_content(admin.first_name), '権限での検索が正しく機能していません'
      expect(page).not_to have_content(general1.first_name), '権限での検索が正しく機能していません'
      expect(page).not_to have_content(general2.first_name), '権限での検索が正しく機能していません'
      expect(page).not_to have_content(general3.first_name), '権限での検索が正しく機能していません'
    end
  end

  describe 'ユーザー詳細' do
    it 'メニューのアクティブ・非アクティブが機能していること' do
      expect(find('.nav-link.active')).to have_content('ユーザー一覧'), 'ユーザー詳細ページにいるときにメニュー「ユーザー一覧」がアクティブになっていません'
      expect(find('.nav-link.active')).not_to have_content('掲示板一覧'), 'ユーザー詳細ページにいるときにメニュー「掲示板一覧」が非アクティブになっていません'
    end

    it 'ユーザーの詳細情報が表示されること' do
      click_on general1.decorate.full_name
      expect(current_path).to eq admin_user_path(general1)
      expect(page).to have_content(general1.id), 'ユーザーIDが表示されていません'
      expect(page).to have_content(general1.role_i18n), 'ユーザーの権限が表示されていません'
      expect(page).to have_content(general1.decorate.full_name), 'ユーザーのフルネームが表示されていません'
    end
  end

  describe 'ユーザー編集' do
    it 'メニューのアクティブ・非アクティブが機能していること' do
      expect(find('.nav-link.active')).to have_content('ユーザー一覧'), 'ユーザー編集ページにいるときにメニュー「ユーザー一覧」がアクティブになっていません'
      expect(find('.nav-link.active')).not_to have_content('掲示板一覧'), 'ユーザー編集ページにいるときにメニュー「掲示板一覧」が非アクティブになっていません'
    end

    it 'ユーザーが編集できること' do
      visit admin_user_path(general1)
      click_on '編集'
      expect(current_path).to eq edit_admin_user_path(general1)
      fill_in '姓', with: '変更後姓'
      fill_in '名', with: '変更後名'
      click_on '更新する'
      sleep 1 # 編集処理が完了するまで待機
      expect(current_path).to eq(admin_user_path(general1)), '管理者用のユーザー詳細ページに遷移していません'
      expect(page).to have_content('ユーザーを更新しました'), 'フラッシュメッセージ「ユーザーを更新しました」が表示されていません'
      expect(page).to have_content('変更後姓 変更後名'), '更新後のフルネームが表示されていません'
    end
  end

  describe 'ユーザー削除' do
    it 'ユーザーを削除できること' do
      visit admin_user_path(general1)
      page.accept_confirm { click_on '削除' }
      sleep 1 # 削除処理が完了するまで待機
      expect(current_path).to eq(admin_users_path), '管理者画面のユーザー一覧ページに遷移していません'
      expect(page).to have_content('ユーザーを削除しました'), 'フラッシュメッセージ「ユーザーを削除しました」が表示されていません'
    end
  end
end
