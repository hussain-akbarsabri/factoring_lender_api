# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', registration: 'signup' },
                     controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  resources :invoices, only: %i[create update index] do
    member do
      patch 'assign_invoice', to: 'invoices#assign_invoice'
    end
  end
  resources :users, only: [:index]
end
