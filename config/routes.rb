ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.root :controller => "main_page", :action => 'index'
  map.servers_sof2 '/servers_sof2', :controller => 'main_page', :action => 'servers_sof2'
  map.sof2_stats '/sof2_stats', :controller => 'main_page', :action => 'sof2_stats'
  map.find '/find', :controller => 'main_page', :action => 'find'
  map.add_server '/add_server', :controller => 'main_page', :action => 'add_server'
  map.save_server '/save_server', :controller => 'main_page', :action => 'save_server'
  map.sof2_game_info '/sof2_game_info', :controller => 'main_page', :action => 'sof2_game_info'
  map.q3_game_info '/q3_game_info', :controller => 'main_page', :action => 'q3_game_info'
  map.cs_game_info '/cs_game_info', :controller => 'main_page', :action => 'cs_game_info'
  map.cod2_game_info '/cod2_game_info', :controller => 'main_page', :action => 'cod2_game_info'
  map.cod4_game_info '/cod4_game_info', :controller => 'main_page', :action => 'cod4_game_info'
  map.login '/login', :controller => 'session', :action => 'create'
  map.logout '/logout', :controller => 'session', :action => 'destroy'
  # sciezki w panelu admina
  map.admin '/admin', :controller => 'admin', :action => 'index'
  map.messages '/messages', :controller => 'admin', :action => 'messages'
  map.new_message '/new_message', :controller => 'admin', :action => 'new_message'
  map.save_message '/save_message', :controller => 'admin', :action => 'save_message'
  map.delete_message '/delete_message', :controller => 'admin', :action => 'delete_message'
  map.edit_message '/edit_message', :controller => 'admin', :action => 'edit_message'
  map.update_message '/update_message', :controller => 'admin', :action => 'update_message'
  map.servers '/servers', :controller => 'admin', :action => 'servers'
  map.players '/players', :controller => 'admin', :action => 'players'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
