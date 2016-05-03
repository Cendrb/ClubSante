class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      if !user.activated?
        respond_to do |format|
          format.html {redirect_to login_url, alert: "Váš účet není aktivován, aktivaci je možné provést odkazem v emailu. #{view_context.link_to 'Znovu odeslat aktivační email', resend_activation_email_path(user.id)}"}
          format.whoa {head 69}
        end
        return
      end
      if params[:permanent]
        cookies.permanent.signed[:user_id] = user.id
      end
      session[:user_id] = user.id
      redirect_to nav_reservations_path
    else
      respond_to do |format|
        format.html {redirect_to login_url, alert: "Neplatné jméno nebo heslo!"}
        format.whoa {head 69}
      end

    end
  end

  def destroy
    cookies.delete :user_id
    session[:user_id] = nil
    redirect_to login_url, notice: 'Uživatel byl odhlášen'
  end
end
