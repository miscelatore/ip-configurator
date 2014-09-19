Rails.application.routes.draw do
  root to: 'visitors#index'
  
  devise_for :users
  
  scope "/admin" do
    resources :users
    resources :roles
  end
  
  resources :operators
  
  resources :hardwares
  
  resources :locations 
  
  resources :addresses
  
  resources :networks
  
  resources :assigned_addresses do
    get :autocomplete_address_ip_address, :on => :collection
  end
  
  get 'renew_dhcp_config' => 'dhcp_commands#make_conf'
  get 'restart_dhcp' => 'dhcp_commands#restart_service'
 
end
