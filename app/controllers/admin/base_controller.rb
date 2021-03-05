class Admin::BaseController < ApplicationController
  layout 'admin/layouts/admin'
  before_action :require_admin
  before_action :set_current_user
  def not_authenticated
    flash[:warning] = 'ログインしてください'
    redirect_to admin_login_path
  end

  def require_admin
    redirect_to root_path, warning: '権限がありません' if current_user.general?
  end

  def set_current_user
    @current_user = User.find(current_user.id)
  end
end
