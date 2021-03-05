require 'rails_helper'

RSpec.describe 'パスワードリセット', type: :system do
  let(:user) { create(:user) }

  it 'パスワードが変更できる' do
    visit new_password_reset_path
    fill_in 'メールアドレス', with: user.email
    click_button '送信'
    expect(page).to have_content('パスワードリセット手順を送信しました'), 'フラッシュメッセージ「パスワードリセット手順を送信しました」が表示されていません'
    visit edit_password_reset_path(user.reload.reset_password_token)
    fill_in 'パスワード', with: '123456789'
    fill_in 'パスワード確認', with: '123456789'
    click_button '更新する'
    expect(current_path).to eq(login_path), 'パスワードリセット後にログイン画面に遷移していません'
    expect(page).to have_content('パスワードを変更しました'), 'フラッシュメッセージ「パスワードを変更しました」が表示されていません'
  end
end
