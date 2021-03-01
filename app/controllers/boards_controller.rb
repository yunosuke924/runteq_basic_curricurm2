class BoardsController < ApplicationController
  before_action :set_board, only: %i[edit update destroy]
  def index
    @boards = Board.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to boards_path, success: (t '.success')
    else
      flash.now[:danger] = t '.fail'
      render :new
    end
  end

  def show
    @board = Board.find(params[:id])
    @comment = Comment.new
    @comments = @board.comments.includes(:user).order(created_at: :desc)
  end

  def edit
    # set_board
  end

  def update
    # set_board
    if @board.update(board_params)
      redirect_to board_path, success: '掲示板を更新しました'
    else
      flash.now[:danger] = '掲示板を更新できませんでした。'
      render :edit
    end
  end

  def destroy
    # set_board
    @board.destroy
    redirect_to boards_path, success: '掲示板を削除しました'
  end

  def bookmarks
    # bookmark = current_user.bookmarks.map(&:board_id)
    # @bookmarking_board = Board.find(bookmark)
    @bookmark_boards = current_user.bookmark_boards.includes(:user).order(created_at: :desc).page(params[:page]).per(20)
  end

  private

  def board_params
    params.require(:board).permit(:title, :body, :board_image, :board_image_cache)
  end

  def set_board
    @board = current_user.boards.find(params[:id])
  end
end
