class SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate(:scope => resource_name)
    if resource.present?
      sign_in(resource_name, resource)
      set_flash_message :notice, :signed_in
      render :json => { :success => true, :redirect_path => dashboard_path }
    else
      render :json => { :success => false }
    end
  end

  def new
    redirect_to root_path
  end
end
