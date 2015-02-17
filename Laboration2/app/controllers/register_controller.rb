class RegisterController < ApplicationController
  #Om man redan är inloggad när man försöker komma till registrerings sidan så redirectas man till den inloggade sidan
  def new
    if is_logged_in?
      redirect_to user_path(current_user)
    end
    @user = User.new
  end

  #Skapar en användare med en nyckel, sparar nyckeln först innan man sparar användare
  def create
    @user = User.new(user_params)
    key = Key.new

    key.key = SecureRandom.hex
    key.user = @user
    key.save
    if @user.save
      flash[:success] = 'User was created, you can now login'
      redirect_to login_path
    else

      flash.now[:danger] = 'Email/Password is invalid'
      render 'new'
    end
  end

  #Parametrar man tillåter när man skapar en användare
  private
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
