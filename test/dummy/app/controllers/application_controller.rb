class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include RemottyRails::SessionsHelper

  before_action :store_location, :authenticate_remotty_user!

end
