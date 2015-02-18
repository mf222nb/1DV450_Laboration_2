module LoginHelper
  #Skapa en session med användaren
  def log_in(user)
    session[:user_id] = user.id
  end

  #Tar bort sessionen och sätter @current_user till nil
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  #Hämtar användaren och returnerar den
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  #Tittar om @current_user är nil eller inte
  def is_logged_in?
    !current_user.nil?
  end

  #Titta om användaren är inloggad
  def check_user
    unless is_logged_in?
      flash[:danger] = 'You have to log in'
      redirect_to login_path
    end
  end

  ##API helpers, Laboration 2

  def api_authentication
    if request.headers['Authorization'].present?

      auth_header = request.headers['Authorization'].split(' ').last

      key = Key.find_by_key(auth_header)

      if key == nil || key.key != auth_header
        render json: {error: 'The provided token wasn´t correct'}, status: :bad_request
      end
    else
      render json: {error: 'Need to include the Authorization header'}, status: :forbidden
    end
  end

end
