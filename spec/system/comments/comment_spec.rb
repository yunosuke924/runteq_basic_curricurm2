require 'rails_helper'

RSpec.describe 'コメント', type: :system do
  let(:me) { create(:user) }
  let(:board) { create(:board) }
  let(:comment_by_me) { create(:comment, user: me, board: board) }
  let(:comment_by_others) { create(:comment, board: board) }

  describe 'コメントのCRUD' do
    before do
      comment_by_me
      comment_by_others
    end
    describe 'コメントの一覧' do
      it 'コメントの一覧が表示されること' do
        login_as_user me
        visit board_path board
        within('#js-table-comment') do
          expect(page).to have_content(comment_by_me.body), 'コメントの本文が表示されていません'
          expect(page).to have_content(comment_by_me.user.decorate.full_name), 'コメントの投稿者のフルネームが表示されていません'
        end
      end
    end

    describe 'コメントの作成' do
      it 'コメントを作成できること', js: true do
        login_as_user me
        visit board_path board
        fill_in 'コメント', with: '新規コメント'
        click_on '投稿'
        sleep 0.1 # sleepしないとテストが通らない
        comment = Comment.last
        within("#comment-#{comment.id}") do
          expect(page).to have_content(me.decorate.full_name), '新規作成したコメントの投稿者のフルネームが表示されていません'
          expect(page).to have_content('新規コメント'), '新規作成したコメントの本文が表示されていません'
        end
      end
      it 'コメントの作成に失敗すること', js: true do
        login_as_user me
        visit board_path board
        fill_in 'コメント', with: ''
        click_on '投稿'
        expect(page).to have_content('コメントを入力してください'), 'コメントを空で投稿した際、エラーメッセージ「コメントを入力してください」が表示されていません'
      end
    end

    describe 'コメントの削除' do
      it 'コメントを削除できること' do
        login_as_user me
        visit board_path board
        within("#comment-#{comment_by_me.id}") do
          page.accept_confirm { find('.js-delete-comment-button').click }
        end
        expect(page).not_to have_content(comment_by_me.body), 'コメントの削除が正しく機能していません'
      end
    end
  end
end
