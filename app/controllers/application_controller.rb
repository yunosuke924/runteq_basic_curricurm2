class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login

  rescue_from StandardError, with: :handle500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, with: :handle404 unless Rails.env.development?

  def handle404
    # unless Rails.env.development?
    render file: Rails.root.join('publc/404'),
           status: :not_found, layout: false
  end

  def handle500(error)
    # unless Rails.env.development?
    logger.debug(error.backtrace.join("\n"))
    logger.info('logger.info')
    logger.info(error)
    ExceptionNotifier.notify_exception(e, env: request.env,
                                          data: { message: 'error' })
    render file: Rails.root.join('public/500'),
           status: :internal_server_error, layout: false
  end

  private

  def not_authenticated
    redirect_to login_path, danger: 'ログインしてください'
  end
end
