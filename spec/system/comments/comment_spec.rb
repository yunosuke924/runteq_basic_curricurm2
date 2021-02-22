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
        expect(page).to have_content('コメントを作成できませんでした'), 'コメント作成失敗時のエラーメッセージ「コメントを作成できませんでした」が表示されていません'
      end
    end

    describe 'コメントの編集' do
      context '他人のコメントの場合' do
        it '編集ボタン・削除ボタンが表示されないこと' do
          login_as_user me
          visit board_path board
          within("#comment-#{comment_by_others.id}") do
            expect(page).not_to have_selector('.js-edit-comment-button'), '他人のコメントに対して編集ボタンが表示されてしまっています'
            expect(page).not_to have_selector('.js-delete-comment-button'), '他人のコメントに対して削除ボタンが表示されてしまっています'
          end
        end
      end
    end
  end
end
