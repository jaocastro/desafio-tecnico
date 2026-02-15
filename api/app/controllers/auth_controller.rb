class AuthController < ApplicationController
  before_action :authenticate!, only: :me

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token(user)
      render json: { token: token, user: user_payload(user) }, status: :ok
    else
      render json: { error: "Email ou senha inválidos" }, status: :unauthorized
    end
  end

  def me
    render json: { user: user_payload(current_user) }, status: :ok
  end

  private

  def user_payload(user)
    { id: user.id, email: user.email }
  end
end
