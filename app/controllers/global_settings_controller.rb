class GlobalSettingsController < ApplicationController
  before_filter :authenticate_admin

  def pass_form
    # just renders form
  end

  def pass_set
    # sets enviromental variable
    if(params[:password])
      ENV["global_password"] = params[:password]
    end
    redirect_to global_pass_form_path
  end
end
