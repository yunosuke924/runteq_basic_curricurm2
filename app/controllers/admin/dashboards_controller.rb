class Admin::DashboardsController < Admin::BaseController
    before_action :require_admin
    layout 'admin/layouts/admin'
    # 管理者一覧ページ
    def index
        @user = User.find(current_user.id)
    end
end
