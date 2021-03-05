class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy edit update]
  layout 'admin/layouts/admin'
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc)
    # debugger
  end

  def show; end

  def destroy
    @user.destroy
    redirect_to admin_root_path
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to edit_admin_user_path, success: '更新しました'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar_image, :avatar_image_cache, :role)
  end
end
