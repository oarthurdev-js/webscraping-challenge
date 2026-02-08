class SessionsController < ApplicationController
  def new
  end

  def create
    result = AuthClient.login(params[:email], params[:password])

    if result[:success]
      # Verify the token immediately to get the user_id for the session
      verify = AuthClient.verify(result[:token])
      
      if verify[:success]
        session[:user_id] = verify[:user_id]
        session[:user_email] = params[:email]
        session[:token] = result[:token]
        redirect_to root_path, notice: "Logged in successfully"
      else
        flash.now[:alert] = "Login failed: Invalid token received"
        render :new
      end
    else
      flash.now[:alert] = result[:error]
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_email] = nil
    session[:token] = nil
    redirect_to login_path, notice: "Logged out"
  end
end
