# frozen_string_literal: true

module Users
  # RegistrationsController
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    before_action :configure_sign_up_params

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role_type])
    end

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: {
          status: { code: 200, message: 'Signed up sucessfully.' },
          data: UserSerializer.new(resource)
        }
      else
        render json: {
          status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end
  end
end
