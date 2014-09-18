DddSampleAppRuby::Application.routes.draw do
    resources :handling_events
    resources :tracking_cargos
    resources :bookings

    root :to => 'bookings#index'
end
