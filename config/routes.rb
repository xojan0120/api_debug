Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      get    '/items',                           to: 'items#get_test'
      post   '/items',                           to: 'items#post_test'
      get    '/items/:item_id',                  to: 'items#get_test_of_path_param'
      post   '/items/auth1',                     to: 'items#get_auth_header_test1'
      post   '/items/auth2',                     to: 'items#get_auth_header_test2'
      post   '/items/auth3',                     to: 'items#before_auth_test'
      #put    '/ill/items/:item_id/archive',          to: 'items#archive'
      #patch  '/ill/items/:item_id/order',            to: 'items#update_order'
      #patch  '/ill/items/:item_id/title',            to: 'items#update_title'
      #get    '/ill/archived_items',                  to: 'archived_items#index'
      #put    '/ill/archived_items/:item_id/restore', to: 'archived_items#restore'
      #delete '/ill/archived_items/:item_id',         to: 'archived_items#destroy'
      #delete '/ill/archived_items',                  to: 'archived_items#destroy_all'
    end
  end
end
