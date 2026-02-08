class RegistrationsController < ApplicationController
  def new
  end

  def create
    result = AuthClient.register(params[:email], params[:password])

    if result[:success]
      redirect_to login_path, notice: "Account created! Please log in."
    else
      flash.now[:alert] = result[:errors].join(", ")
      render :new
    end
  end
end
