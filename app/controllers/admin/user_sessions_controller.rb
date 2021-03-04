class Admin::UserSessionsController < Admin::BaseController
  layout 'admin/layouts/admin_login'
  # 新規ログイン画面
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user.admin?
      if @user
        redirect_to admin_root_path, success: 'ログインしました'
      else
        render :new, danger: 'ログインに失敗しました'
      end
    else
      redirect_to root_path, success: 'ログインしました'
    end
  end

  def destroy
    logout
    flash[:success] = 'ログアウトしました'
    redirect_to admin_login_path
  end
end
