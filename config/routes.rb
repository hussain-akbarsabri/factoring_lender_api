# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', registration: 'signup' },
                     controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  resources :lenders, only: :index do
    member do
      get 'lender_invoices', to: 'lenders#lender_invoices'
    end
    resources :invoices, only: :index
  end
  resources :borrowers, only: [], shallow: true do
    member do
      get 'borrower_invoices', to: 'borrowers#borrower_invoices'
    end
    resources :invoices, only: %i[create] do
      member do
        patch 'assign_invoice', to: 'invoices#assign_invoice'
      end
    end
  end
end
