class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    begin
      resource.save
    rescue ActiveRecord::RecordNotUnique
      render json: {message: "Email already taken."}, status: :conflict
      return
    end

    yield resource if block_given?
    if resource.persisted?
      render json: {message: "Signed up."}
    else
      register_failed
    end
  end

  private

  def sign_up_params
    params.permit(:email, :password, :phone_number)
  end

  def register_failed
    render json: {message: "Signed up failure."}, status: :unprocessable_entity
  end
end
