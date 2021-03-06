class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login

  rescue_from StandardError, with: :handle_500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, with: :handle_404 unless Rails.env.development?

  def handle_404
    # unless Rails.env.development?
    render file: Rails.root.join('public', '404.html'),
           status: :not_found, layout: false
  end

  def handle_500(e)
    # unless Rails.env.development?
    logger.debug(e.backtrace.join("\n"))
    logger.info('logger.info')
    logger.info(e)
    ExceptionNotifier.notify_exception(e, env: request.env,
                                          data: { message: 'error' })
    render file: Rails.root.join('public', '500.html'),
           status: :internal_server_error, layout: false
  end

  private

  def not_authenticated
    redirect_to login_path, danger: 'ログインしてください'
  end
end
