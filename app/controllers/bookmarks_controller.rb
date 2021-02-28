class BookmarksController < ApplicationController
  def create
    @board = Board.find(params[:board_id])
    current_user.bookmark(@board)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
    # flash[:success] = 'ブックマークしました'
    # redirect_back(fallback_location: root_path)
  end

  def destroy
    @board = current_user.bookmarks.find(params[:id]).board
    current_user.unbookmark(@board)
    # flash[:success] = 'ブックマークを外しました'
    # redirect_back(fallback_location: root_path)
  end
end
