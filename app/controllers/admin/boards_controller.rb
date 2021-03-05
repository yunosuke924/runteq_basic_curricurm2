class Admin::BoardsController < ApplicationController
  before_action :set_board, only: %i[show destroy edit update]
  layout 'admin/layouts/admin'
  def index
    # @boards = Board.all
    @q = Board.ransack(params[:q])
    @boards = @q.result(distinct: true).includes(:user).order(created_at: :desc)
    # 一旦避難 .page(params[:page])
  end

  def show; end

  def destroy
    @board.destroy
    redirect_to admin_boards_path, success: '掲示板を削除しました'
  end

  def edit; end

  def update
    if @board.update(board_params)
      redirect_to admin_board_path, success: '掲示板を更新しました'
    else
      render :edit
    end
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :body, :email, :board_image, :board_image_cache)
  end
end
