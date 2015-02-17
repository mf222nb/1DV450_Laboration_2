class UsersController < ApplicationController

  before_action :check_user, only: [:show, :destroy]
  before_action :correct_user, only: [:show]

  #Hämtar ut alla nycklar som har en användare och hämtar ut en enskild användare med en enskild nyckel
  def show
    @all_users = Key.all
    @key = Key.find_by_user_id(params[:id])
    @user = User.find(params[:id])
  end

  #Tar bort en nyckel på en användare
  def destroy
    if Key.find_by_user_id(params[:id]).destroy

      flash[:success] = "Your key has been removed"
      redirect_to user_path
    else
      flash.now[:danger] = "Something went wrong"
      render 'show'
    end
  end

  #Skapar en ny nyckel på en användare
  def create
    key = Key.new
    key.key = SecureRandom.hex
    key.user = User.find(params[:id])

    if key.save
      flash[:success] = "You have got a new key"
      redirect_to user_path(current_user)
    else
      flash.now[:danger] = "Something went wrong"
      render 'show'
    end
  end

  #Tittar om det är rätt användare som är inne
  private
  def correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user) unless @user == current_user || current_user.admin?
  end
end
