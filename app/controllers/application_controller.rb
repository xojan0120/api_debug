class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # ------------------------------------------------------------------------
  # railsでapiを構築するにあたってCORSに関する事前設定
  # ------------------------------------------------------------------------
  # CORS(Cross-Origin Resource Sharing)は、ブラウザが
  # オリジン(HTMLを読み込んだサーバのこと)以外のサーバから
  # データを取得する仕組み
  # ------------------------------------------------------------------------
  # 設定1. Gemfileの gem 'rack-cors'のコメントアウトを外す
  # 設定2. config/initializers/cors.rbを設定する。
  # ------------------------------------------------------------------------

  # ------------------------------------------------------------------------
  # rescue_fromについて
  # ------------------------------------------------------------------------
  # rescue_fromは後に書いたもののほうが優先される
  # railsガイドではrescue_fromにExceptionを指定するのは非推奨。
  # https://railsguides.jp/action_controller_overview.html#rescue-from

  #rescue_from Exception,                      with: :render_500
  rescue_from ActiveRecord::RecordNotFound,   with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  # 下記メソッド内のstatusはステータスコードを返すメソッド
  def render_200(message, data)
    render_response(status, message, data)
  end

  def render_404(e)
    status, message  = 404, 'Not found'
    logger_error(e, status, message)
    render_response(status, message)
  end

  def render_422(message)
    status = 422
    logger_error(nil, status, message)
    render_response(status, message)
  end

  private

    def logger_error(e, status, message)
      logger.error "render_#{status}: #{message}"
      logger.error e.backtrace.join("\n") if e
    end

    def render_response(status, message, data = "")
      render status: status, json: { status: status, message: message, data: data }
    end

end
