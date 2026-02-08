class AuthController < ApplicationController
  def request_token
    user = User.find_or_create_by!(email: params[:email])
    token = AuthToken.generate_for(user)

    Rails.logger.info "Auth Token: #{token.token} for User: #{user.email}"

    head :ok
  end

  def verify
    decoded = JsonWebToken.decode(params[:token])
    return head :unauthorized unless decoded

    render json: {
      user_id: decoded[:user_id]
    }
  end


  def register
    user = User.new(user_params)

    if user.save
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
