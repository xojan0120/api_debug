module Api
  module V1
    class ItemsController < ApplicationController
      before_action :authenticate, only: :before_auth_test

      def get_test
        items = Item.all
        render_200 'success', items
      end

      def post_test
        if params['title']
          added_item = Item.create(title: params['title'])
          render_200 'success', added_item
        else
          render_422 'title param not found'
        end
      end

      def get_test_of_path_param
        item_id = params['item_id']
        render_200 'get item_id', {item_id: item_id}
      end

      def get_auth_header_test1
        # authenticate_with_http_tokenは
        # Authorizationヘッダーがあればブロックを評価
        # なければnilを返す
        authenticate_with_http_token do |token, options|
          render_200 'get auth header1', {token: token}
        end
      end

      def get_auth_header_test2
        # authenticate_or_request_with_http_tokenは
        # Authorizationヘッダーがあればブロックを評価し
        # なければHTTP Token: Access deniedを返してくれる
        authenticate_or_request_with_http_token do |token, options|
          render_200 'get auth header2', {token: token}
        end
      end

      # 下記のような認証メソッドを作り、before_actionコールバックを
      # 使えば、各アクションの実行前に認証処理を挟むことができる。
      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          token == 'TEST-TOKEN'
        end
      end

      def before_auth_test
        render_200 'authenticated!', {something: "hoge"}
      end
      
      def archive
        # トランザクションについてメモ
        #
        # 例えば下記のような場合
        #   1. Item.delete_itemに成功
        #   2. ArchivedItem.add_itemに失敗
        #   結果: Itemが削除されただけの状態になってしまい不整合発生
        #
        # [対策1]
        #   下記のようにtransactionで囲めば、transactionブロック内で
        #   エラーが発生した場合、ブロック内での変更はロールバックされる。
        #   transaction do
        #     deleted_item = Item.delete_item(params['item_id'])
        #     ArchivedItem.add_item(deleted_item.title)
        #   end
        #
        # [対策2] (採用)
        #   Itemクラス内でItem.delete_itemとArchivedItem.add_itemする。
        #   Itemクラス内でエラーが発生した場合、クラス内での変更は
        #   ロールバックされる。
        
        Item.archive_item(params['item_id'])
        render_200 'archived item'
      end

      def update_order
        Item.move_item(params['item_id'], params['from'], params['to'])
        render_200 'moved item'
      end

      def update_title
        Item.change_item(params['item_id'], params['title'])
        render_200 'changed item'
      end
    end
  end
end
