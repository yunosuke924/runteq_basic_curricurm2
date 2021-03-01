require 'rails_helper'

RSpec.describe 'プロフィール', type: :system do
  let(:user) { create(:user) }
  before { login_as_user user }
  it 'プロフィールの詳細が見られること' do
    visit boards_path
    find('#header-profile').click
    click_on 'プロフィール'
    expect(current_path).to eq(profile_path), 'プロフィールページに遷移していません'
    expect(page).to have_content(user.email), 'プロフィールページにメールアドレスが表示されていません'
    expect(page).to have_content(user.decorate.full_name), 'プロフィールページにフルネームが表示されていません'
  end

  it 'プロフィールの編集ができること' do
    visit profile_path
    click_on '編集'
    expect(current_path).to eq(edit_profile_path), 'プロフィール編集ページに遷移していません'
    fill_in 'メールアドレス', with: 'edit@example.com'
    fill_in '姓', with: '編集後姓'
    fill_in '名', with: '編集後名'
    file_path = Rails.root.join('spec', 'fixtures', 'example.jpg')
    attach_file('アバター', file_path)
    click_button '更新する'
    expect(current_path).to eq(profile_path), 'プロフィールページに遷移していません'
    expect(page).to have_content('ユーザーを更新しました'), 'フラッシュメッセージ「ユーザーを更新しました」が表示されていません'
    expect(page).to have_content('edit@example.com'), '更新後のメールアドレスが表示されていません'
    expect(page).to have_content('編集後姓 編集後名'), '更新後のフルネームが表示されていません'
    expect(page).to have_selector("img[src$='example.jpg']"), '更新後のアバターが表示されていません'
  end

  it 'プロフィールの編集に失敗すること' do
    visit profile_path
    click_on '編集'
    expect(current_path).to eq(edit_profile_path), 'プロフィール編集ページに遷移していません'
    fill_in 'メールアドレス', with: ''
    fill_in '姓', with: ''
    fill_in '名', with: ''
    click_button '更新する'
    expect(page).to have_content('ユーザーを更新できませんでした'), 'フラッシュメッセージ「ユーザーを更新できませんでした」が表示されていません'
    expect(page).to have_content('メールアドレスを入力してください'), 'エラーメッセージ「メールアドレスを入力してください」が表示されていません'
    expect(page).to have_content('姓を入力してください'), 'エラーメッセージ「姓を入力してください」が表示されていません'
    expect(page).to have_content('名を入力してください'), 'エラーメッセージ「名を入力してください」が表示されていません'
  end
end
