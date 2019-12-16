# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :merchant_space do
    get '/', to: 'dashboard#index'
  end

  namespace :admin_space do
    get '/', to: 'base#index'
  end

  post 'sign_in', to: 'sessions#sign_in'
  root to: 'sessions#signin_form'
end
