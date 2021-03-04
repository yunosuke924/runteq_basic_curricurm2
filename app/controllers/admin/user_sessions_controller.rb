class Admin::UserSessionsController < Admin::BaseController
  layout 'admin/layouts/admin_login'
  # before_action :require_admin, only: [:create]
  # 新規ログイン画面
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to admin_root_path, success: 'ログインしました'
    else
      render :new, danger: 'ログインに失敗しました'
    end
  end

  def destroy
    logout
    flash[:success] = 'ログアウトしました'
    redirect_to admin_login_path
  end
end
