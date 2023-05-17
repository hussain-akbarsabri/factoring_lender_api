# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  def index
    users = if params[:role_type] == LENDER
              Lender.all
            elsif params[:role_type] == BORROWER
              Borrower.all
            else
              User.all
            end
    render json: users, status: :ok
  end
end
