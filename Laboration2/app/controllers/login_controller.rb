class LoginController < ApplicationController
  #Om man redan är inloggad när man kommer till sidan så redirectas man till den inloggade sidan
  def index
    if is_logged_in?
      redirect_to user_path(current_user)
    end
  end

  def create
    #Hämtar ut användaren med ett visst namn
    user = User.find_by(name: params[:login][:name].downcase)

    if user && user.authenticate(params[:login][:password])

      log_in user

      redirect_to user

    else

      flash.now[:danger] = 'Wrong email or password'
      render 'index'
    end
  end

  #När man loggar ut så förstörs sessionen och man kommer tillbaka till login sidan
  def destroy
    log_out

    flash[:success] = 'You have logged out'
    redirect_to root_url
  end
end
