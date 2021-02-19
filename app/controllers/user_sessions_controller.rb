class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      # flash[:success] = 'ログインしました'
      redirect_to root_path, success: t('.success')
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
