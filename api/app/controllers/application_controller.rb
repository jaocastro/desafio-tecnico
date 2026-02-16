class ApplicationController < ActionController::API
  include Authenticatable
# include Pagy::Backend

  rescue_from ActiveRecord::RecordNotFound do |_error|
    render json: { error: "Registro não encontrado" }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |error|
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end
end
