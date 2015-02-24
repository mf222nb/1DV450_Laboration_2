class Api::CreatorController < ApplicationController

  protect_from_forgery with: :null_session

  respond_to :json, :xml

  before_action :api_authentication

  rescue_from ActionController::UnknownFormat, with: :raise_bad_format

  def index
    creator = Creator.all

    if creator.empty?
      @error = ErrorMessage.new("Could not find the Creators", "There is no Creators to be shown")
      respond_with @error, status: :ok
    else
      respond_with creator
    end
  end

  def show
    creator = Creator.find(params[:id])
    creator_events = creator.events
    respond_with creator_events

  rescue ActiveRecord::RecordNotFound
    @error = ErrorMessage.new("Could not find that Creator. Are you using the right creator_id?", "The Creator was not found!")
    respond_with @error, status: :not_found
  end

  def search
    creator = Creator.find_by_name(params[:name])
    creator_events = creator.events
    respond_with creator_events
  end

  def api_auth
    creator = Creator.find_by(name: request.headers[:name])

    if creator && creator.authenticate(request.headers[:password])
      render json: { auth_token: encodeJWT(creator) }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end
end
