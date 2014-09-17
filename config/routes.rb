DddSampleAppRuby::Application.routes.draw do
    resources :handling_events
    resources :tracking_cargos
    resources :bookings do
      member do
        get 'route'
      end
    end

    root :to => 'bookings#index'
end
