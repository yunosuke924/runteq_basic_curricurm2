module SystemHelper
  def login_as_general
    general_user = create(:user)
    visit '/login'
    fill_in 'メールアドレス', with: general_user.email
    fill_in 'パスワード', with: '12345678'
    click_button 'ログイン'
  end
end
