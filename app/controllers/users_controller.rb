# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  def index
    # make constants
    users = if params[:role_type] == 'lender'
              Lender.all
            elsif params[:role_type] == 'borrower'
              Borrower.all
            else
              User.all
            end
    render json: users, status: :ok
  end
end
