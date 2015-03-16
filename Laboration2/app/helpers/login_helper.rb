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

  #Kontrollerar om en användare skickar med en giltig API-nyckel
  def api_authentication
    if request.headers['Authorization'].present?
      #Tar den sista delen i headern
      auth_header = request.headers['Authorization'].split(' ').last

      key = Key.find_by_key(auth_header)

      if key == nil || key.key != auth_header
        render json: {error: 'The provided token wasn´t correct'}, status: :bad_request
      end
    else
      render json: {error: 'Need to include the Authorization header'}, status: :forbidden
    end
  end

  #Kontrollerar så att en användare skickar med en token
  def user_authenticate
    if request.headers["Userkey"].present?
      #Tar den sista delen i headern
      auth_header = request.headers['Userkey'].split(' ').last

      @token_payload = decodeJWT auth_header.strip
      if !@token_payload
        render json: { error: 'The provided token wasn´t correct' }, status: :bad_request
      else
        @creator_id = @token_payload[0]['creator_id']
      end
    else
      render json: { error: 'Need to include the Userkey header' }, status: :forbidden # The header isn´t present
    end
  end

  #Skapar en JSON Web Token som har en längd på 2 timmar
  def encodeJWT(creator, exp=2.hours.from_now)
    #Binder token till en viss användare
    payload = { creator_id: creator.id }
    payload[:exp] = exp.to_i

    #Encode the payload whit the application secret, and a more advanced hash method (skapar header med JWT gem)
    JWT.encode( payload, Rails.application.secrets.secret_key_base, "HS512")
  end

  #Tar emot och dekrypterar en token
  def decodeJWT(token)
    payload = JWT.decode(token, Rails.application.secrets.secret_key_base, "HS512")
    #Kontrollerar tiden på token
    if payload[0]["exp"] >= Time.now.to_i
      payload
    else
      puts "The token has expired, please log in again to get a new one"
      false
    end
      #Fångar felet om token var fel
  rescue => error
    puts error
    nil
  end
end
