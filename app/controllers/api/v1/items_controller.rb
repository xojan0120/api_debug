module Api
  module V1
    class ItemsController < ApplicationController
      before_action :authenticate, only: :before_auth_test

      def get_test
        items = Item.all
        render status: 200, json: { message: 'Success' }
      end

      def post_test
        if params['title']
          added_item = Item.create(title: params['title'])
          render status: 200, json: { message: 'Success', added_item: added_item }
        else
          render status: 422, json: { message: 'Title param not found' }
        end
      end

      def get_test_of_path_param
        item_id = params['item_id']
        render status: 200, json: { message: 'Success', item_id: item_id }
      end

      def get_auth_header_test1
        # authenticate_with_http_tokenは
        # Authorizationヘッダーがあればブロックを評価
        # なければnilを返す
        authenticate_with_http_token do |token, options|
          render status: 200, json: { message: 'Get auth header1', token: token }
        end
      end

      def get_auth_header_test2
        # authenticate_or_request_with_http_tokenは
        # Authorizationヘッダーがあればブロックを評価し
        # なければHTTP Token: Access deniedを返してくれる
        authenticate_or_request_with_http_token do |token, options|
          render status: 200, json: { message: 'Get auth header2', token: token }
        end
      end

      # 下記のような認証メソッドを作り、before_actionコールバックを
      # 使えば、各アクションの実行前に認証処理を挟むことができる。
      def authenticate
        authenticate_with_http_token do |token, options|
          begin
            decoded_token = FirebaseHelper::Auth.verify_id_token(token)
          rescue => error
            logger.error error.message
            logger.error error.backtrace.join("\n")
            render status: 401, json: { message: 'Unauthorized' } and return
          end

          if decoded_token['uid'] != params['uid']
            logger.error 'Firebase uid unmatch'
            render status: 401, json: { message: 'Unauthorized' }
          end
        end
      end

      def before_auth_test
        render status: 200, json: { message: 'authenticated!', title: params['title'] }
      end
      
    end
  end
end
