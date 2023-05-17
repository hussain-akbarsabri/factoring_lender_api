# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  include Pundit

  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
  end
end
