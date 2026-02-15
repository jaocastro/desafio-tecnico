module Authenticatable
  extend ActiveSupport::Concern

  private

  def current_user
    return @current_user if defined?(@current_user)

    header = request.headers["Authorization"]
    token = header&.split(" ")&.last
    return @current_user = nil unless token

    payload = JWT.decode(token, jwt_secret, true, algorithm: "HS256").first
    @current_user = User.find_by(id: payload["user_id"])
  rescue JWT::DecodeError
    @current_user = nil
  end

  def authenticate!
    render json: { error: "Não autorizado" }, status: :unauthorized unless current_user
  end

  def jwt_secret
    Rails.application.credentials.secret_key_base || ENV.fetch("SECRET_KEY_BASE", "dev-secret")
  end

  def encode_token(user)
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, jwt_secret, "HS256")
  end
end
