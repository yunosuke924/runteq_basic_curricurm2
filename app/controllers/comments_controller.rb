class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.board_id = params[:board_id]

    if @comment.save
      redirect_back(fallback_location: root_path)
      flash[:success] = t '.success'
    else
      redirect_to board_path(@comment.board_id), danger: (t '.fail')
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    # render root_path
    redirect_back(fallback_location: root_path)
  end

  def comment_params
    params.require(:comment).permit(:body, :board_id)
  end
end
