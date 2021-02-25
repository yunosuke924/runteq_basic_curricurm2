require 'rails_helper'

describe 'Board', type: :request do
  let!(:user) { create(:user) }
  let!(:board) { create(:board) }
  before { login_user(user, '12345678', login_path) }

  it '他人の掲示板の編集画面に遷移できないこと' do
    expect { get edit_board_path(board) }.to raise_error ActiveRecord::RecordNotFound
  end

  it '他人の掲示板を更新できないこと' do
    expect { patch board_path(board) }.to raise_error ActiveRecord::RecordNotFound
  end

  it '他人の掲示板を削除できないこと' do
    expect { delete board_path(board) }.to raise_error ActiveRecord::RecordNotFound
  end
end
