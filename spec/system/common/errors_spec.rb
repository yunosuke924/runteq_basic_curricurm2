require 'rails_helper'

RSpec.describe '掲示板', type: :system do
  let(:user) { create(:user) }
  let(:board) { create(:board, user: user) }

  it '存在し得ないリソースにアクセスしたときに404エラーページが表示されること' do
    login_as_general
    visit board_path(10000)
    expect(page).to have_content('ページが見つかりません'), '404ページに「ページが見つかりません」というテキストが見つかりません'
  end

  # 500番台のエラーはシステムスペックでは検知不可なので省略
end
