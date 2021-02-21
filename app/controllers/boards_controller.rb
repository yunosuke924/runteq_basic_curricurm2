class BoardsController < ApplicationController
  def index
    @boards = Board.all.includes(:user).order(created_at: :desc)
  end

  def new
    @board = Board.new
    @errors_messages = []
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to boards_path, success: (t '.success')
    else
      @errors_messages = @board.errors.full_messages
      flash.now[:danger] = t '.fail'
      render :new
    end
  end

  private

  def board_params
    params.require(:board).permit(:title, :body)
  end
end
