Rails.application.routes.draw do
  resources :urls, :only => [:create]
  root "urls#index"
  #Decoding happens here
  get ':key', to: 'urls#show'
end
