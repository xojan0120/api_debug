class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  # ------------------------------------------------------------------------
  # rescue_fromについて
  # ------------------------------------------------------------------------
  # rescue_fromは後に書いたもののほうが優先される
  # railsガイドではrescue_fromにExceptionを指定するのは非推奨。
  # https://railsguides.jp/action_controller_overview.html#rescue-from

  #rescue_from Exception,                      with: :render_500
  rescue_from ActiveRecord::RecordNotFound,   with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  def render_404(error)
    logger.error '404 Not found'
    logger.error error.backtrace.join("\n")
    render status: 404, json: { message: 'Not found' }
  end
end
