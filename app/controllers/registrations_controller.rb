class RegistrationsController < Devise::RegistrationsController
  def update
    # For Rails 4
#    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # required for settings form to submit when password is left blank
    # if account_update_params[:password].blank?
    #   account_update_params.delete("password")
    #   account_update_params.delete("password_confirmation")
    #   account_update_params.delete("current_password")
    # end
    # binding.pry

    @user = User.find(current_user.id)

    if @user.update_without_password(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  private

  def account_update_params
    params.require(:user).permit(:age, :gender, :interested_in, :location, :bio, :email, :image)
  end

end
