module RemottyRails
  class SessionsController < ApplicationController
    skip_before_action :authenticate_remotty_user!

    def new
      redirect_to '/auth/remotty'
    end

    def create
      remotty_user = User.find_or_create_with_omniauth(request.env['omniauth.auth'])
      redirect_url = after_signin_url
      reset_session
      session[:remotty_user_id] = remotty_user.id
      redirect_to redirect_url
    end

    def destroy
      reset_session
      redirect_to main_app.root_url
    end

    def failure
    end
  end
end
