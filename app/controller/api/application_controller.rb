# app/controllers/api/application_controller.rb
module Api
  class ApplicationController < ActionController::API
    #include Pundit
    # -- Rescue common ActiveRecord exceptions
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActiveRecord::RecordNotSaved, with: :unprocessable_entity

    # -- Rescue Doorkeeper invalid token errors
    rescue_from Doorkeeper::Errors::InvalidToken, with: :unauthorized

    # -- Optionally handle Pundit errors if used
    #rescue_from Pundit::NotAuthorizedError, with: :forbidden if defined?(Pundit)

    # -- Customize Doorkeeper error response globally
    Doorkeeper::OAuth::ErrorResponse.class_eval do
      define_method :body do
        {
          error: I18n.t("doorkeeper.errors.messages.#{name}", default: description)
        }
      end

      define_method :status do
        :unauthorized
      end
    end

    private

    def not_found(exception)
      render json: { error: exception.message }, status: :not_found # 404
    end

    def unprocessable_entity(exception)
      render json: { error: exception.message }, status: :unprocessable_entity # 422
    end

    def forbidden(_exception = nil)
      render json: { error: "Forbidden - You don’t have access to perform this action." }, status: :forbidden # 403
    end

    def unauthorized(_exception = nil)
      render json: { error: "Unauthorized - Please login or provide a valid token." }, status: :unauthorized # 401
    end
  end
end
