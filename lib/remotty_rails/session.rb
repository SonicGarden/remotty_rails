module RemottyRails
  module Session
    extend ActiveSupport::Concern

    included do
      helper_method :current_remotty_user, :remotty_user_signed_in?
    end

    def authenticate_remotty_user!
      unless remotty_user_signed_in?
        redirect_to signin_url
      end
    end

    def remotty_user_signed_in?
      !!current_remotty_user
    end

    def current_remotty_user
      @current_remotty_user ||= RemottyRails::User.find_by(id: session[:remotty_user_id])
    end

    def store_location
      return unless request.get?
      paths_not_to_be_stored = [
        main_app.root_path,
        signin_path,
        signout_path,
        create_session_path
      ]
      session[:previous_url] = request.fullpath if !paths_not_to_be_stored.index(request.path) && !request.xhr?
    end

    def after_signin_url
      session[:previous_url] || main_app.root_url
    end
  end
end
