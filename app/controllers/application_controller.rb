class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login

  rescue_from StandardError, with: :handle500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, with: :handle404 unless Rails.env.development?

  private

  def handle404
    # unless Rails.env.development?
    render file: 'public/404.html', status: :not_found, layout: 'application'
  end

  def handle500(error)
    # unless Rails.env.development?
    logger.debug(error.backtrace.join("\n"))
    logger.info('logger.info')
    logger.info(error)
    ExceptionNotifier.notify_exception(e, env: request.env,
                                          data: { message: 'error' })
    render file: 'public/500.html', status: :internal_server_error, layout: 'application'
  end

  def not_authenticated
    redirect_to login_path, danger: 'ログインしてください'
  end
end
