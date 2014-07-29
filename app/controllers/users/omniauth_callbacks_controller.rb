class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def spotify
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    @user.save!
    if @user.persisted?
      Track.refresh(request.env['omniauth.auth'])
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.spotify_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def after_sign_in_path_for(user)
    if user.email != 'temp@gmail.com'
      super user
    else
      finish_signup_path(user)
    end
  end

end
