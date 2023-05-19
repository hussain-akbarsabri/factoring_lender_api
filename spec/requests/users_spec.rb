# frozen_string_literal: true

# spec/requests/users_spec.rb

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  include Devise::Test::IntegrationHelpers

  describe 'POST /signup' do
    let(:valid_attributes) { { email: 'test@example.com', password: 'password', name: 'John Doe', role_type: 'lender' } }
    let(:invalid_attributes) { { email: 'test@example.com', password: '', name: '', role_type: '' } }

    context 'when valid attributes are provided' do
      it 'creates a new user' do
        expect do
          post '/signup', params: { user: valid_attributes }
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid attributes are provided' do
      it 'does not create a new user' do
        expect do
          post '/signup', params: { user: invalid_attributes }
        end.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /login' do
    let!(:user) { User.create(email: 'test@example.com', password: 'password', name: 'John Doe', role_type: 'lender') }

    context 'when valid credentials are provided' do
      it 'returns an authentication token' do
        post '/login', params: { user: { email: user.email, password: user.password } }

        expect(response).to have_http_status(:ok)
        expect(response.headers['Authorization']).to be_present
      end
    end

    context 'when invalid credentials are provided' do
      it 'returns an unauthorized status' do
        post '/login', params: { user: { email: user.email, password: 'wrong_password' } }

        expect(response).to have_http_status(:unauthorized)
        expect(response.headers['Authorization']).to be_nil
      end
    end
  end

  describe 'DELETE /logout' do
    let!(:user) { User.create(email: 'test@example.com', password: 'password', name: 'John Doe', role_type: 'lender') }

    context 'when a user is authenticated' do
      it 'logs out the user and destroys token' do
        sign_in user
        delete '/logout'

        expect(response.headers['Authorization']).to be_nil
      end
    end

    context 'when a user is not authenticated' do
      it 'returns an unauthorized status' do
        delete '/logout'

        expect(response).to have_http_status(:unauthorized)
        expect(response.headers['Authorization']).to be_nil
      end
    end
  end
end
