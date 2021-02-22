class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create destroy]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      # flash[:success] = 'ログインしました'
      redirect_to boards_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render action: 'new'
    end
  end

  def destroy
    logout
    flash[:success] = 'ログアウトしました'
    redirect_to root_path
  end
end
