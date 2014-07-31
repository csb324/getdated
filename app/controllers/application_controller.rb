class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def ensure_signup_complete
    return if action_name == 'finish_signup'

    if current_user.email == '12324857203948572304857230948750923847509283475@example.com'
      redirect_to finish_signup_path(current_user)
    end
  end

  private

  def new_session_path(scope)
    new_user_session_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password,
      :password_confirmation, :remember_me, :remote_image_url, :image, :image_cache) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password,
      :password_confirmation, :current_password, :remote_image_url, :image, :image_cache, :bio) }
  end

end
