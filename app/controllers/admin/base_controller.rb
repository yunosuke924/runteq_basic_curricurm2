class Admin::BaseController < ApplicationController
  skip_before_action :require_login

  def require_admin
    user = User.find_by(email: params[:email])

    if user.general?
        redirect_to root_path, success: '権限がありません'
    end
  end
    
end
