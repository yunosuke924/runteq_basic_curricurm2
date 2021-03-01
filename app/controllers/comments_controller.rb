class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
    #   # redirect_back(fallback_location: root_path)
    #   redirect_to board_path(comment.board), success: (t '.success') # 作成したコメントの対象の投稿の詳細画面に遷移
    #   # flash[:success] = t '.success'
    # else
    #   redirect_to board_path(comment.board), danger: (t '.fail')
    # end
  end

  def destroy
    # @comment = current_user.comments.find(params[:id])
    @comment = Comment.find(params[:id])
    @comment.destroy!
    # render root_path
    # redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(board_id: params[:board_id])
  end
end
