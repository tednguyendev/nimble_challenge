Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    api_version(:module => "V1", :path => {:value => "v1"}) do
      post '/sign-up', to: 'authenticate#sign_up'
      get '/verify-email', to: 'authenticate#verify_email'
      post '/sign-in', to: 'authenticate#sign_in'

      scope :reports do
        post '', to: 'reports#create'
        get '', to: 'reports#list'
        get '/:id', to: 'reports#get'
      end

      scope :keywords do
        get '/:id/html-source', to: 'keywords#get_html_source'
      end
    end
  end
end
