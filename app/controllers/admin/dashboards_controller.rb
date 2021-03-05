class Admin::DashboardsController < Admin::BaseController
  # 管理者一覧ページ
  def index
    @user = User.find(current_user.id)
  end
end
