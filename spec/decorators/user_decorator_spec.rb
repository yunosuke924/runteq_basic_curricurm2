require 'rails_helper'

describe UserDecorator do
  let(:user) { create(:user) }

  it 'フルネームを返すこと' do
    expect(user.decorate.full_name).to eq("#{user.last_name} #{user.first_name}"), 'フルネームは姓名を半角スペース1つ区切りで表示してください'
  end
end
