class BookmarksController < ApplicationController
  def create
    @bookmark = Bookmark.new(board_id: params[:id], user_id: current_user.id)
    if @bookmark.save
      flash[:success] = 'ブックマークしました'
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path
    end
  end

  def destroy
    @bookmark = Bookmark.find_by(board_id: params[:id], user_id: current_user.id)
    @bookmark.destroy
    flash[:success] = 'ブックマークを外しました'
    redirect_back(fallback_location: root_path)
  end

  def boards
    bookmarks = current_user.bookmarks.map(&:board_id)
    @bookmarks = Board.find(bookmarks)
  end
end
