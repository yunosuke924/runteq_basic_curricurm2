class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :require_admin, only: %i[new create]
  skip_before_action :set_current_user
  layout 'admin/layouts/admin_login'
  # before_action :require_admin, only: [:create]
  # 新規ログイン画面
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to admin_root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    flash[:success] = 'ログアウトしました'
    redirect_to admin_login_path
  end
end
