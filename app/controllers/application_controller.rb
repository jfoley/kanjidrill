class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  after_filter :set_access_control_headers

  private
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
end
