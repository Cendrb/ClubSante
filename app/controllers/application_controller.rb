class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
  def authenticate_for_level(required_level)
    current = current_user
    if current.access_level >= required_level
      return true
    else
      if required_level == 0
        redirect_to :login, alert: 'Pro přístup do této sekce se musíte přihlásit'
      end
      redirect_to :root, alert: 'Nemáte dostatečná oprávnění pro přístup do této sekce'
    end
  end

  def current_user
    return User.first
    begin
      if !session[:user_id].nil?
        User.find(session[:user_id])
      else if !cookies.signed[:user_id].nil?
          User.find(cookies.signed[:user_id])
        end
      end
    rescue Exception => e
      cookies.delete :user_id
      session[:user_id] = nil
      puts "Exception rescued! (#{e.message})"
    end
  end

  def access_for_level?(required_level)
    return current_user.access_level >= required_level
  end

  helper_method :access_for_level?, :current_user
end
