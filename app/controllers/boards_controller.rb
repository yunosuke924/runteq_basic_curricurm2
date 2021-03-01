class BoardsController < ApplicationController
  before_action :set_board, only: %i[edit update destroy]
  def index
    @q = Board.ransack(params[:q])
    @boards = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
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
    @q = current_user.bookmark_boards.ransack(params[:q])
    @bookmark_boards = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  private

  def board_params
    params.require(:board).permit(:title, :body, :board_image, :board_image_cache)
  end

  def set_board
    @board = current_user.boards.find(params[:id])
  end
end
