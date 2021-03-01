class ProfilesController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to profile_path, success: 'ユーザーを更新しました'
    else
      flash.now[:danger] = 'ユーザーを更新できませんでした'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar_image, :avatar_image_cache)
  end
end
