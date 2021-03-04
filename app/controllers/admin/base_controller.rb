class Admin::BaseController < ApplicationController
  skip_before_action :require_login

  def require_admin
    if current_user.present?
      redirect_to root_path, success: '権限がありません' if current_user.general?
    else
      redirect_to root_path, success: '権限がありません'
    end
  end
end
