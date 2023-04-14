class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    jwt = JWT.encode({user_id: resource.id}, ENV["DEVISE_JWT_SECRET_KEY"])
    render json: {message: "Logged in.", token: jwt}, status: :ok
  end

  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    render json: {message: "Logged out."}, status: :ok
  end

  def log_out_failure
    render json: {message: "Logged out failure."}, status: :unauthorized
  end
end
