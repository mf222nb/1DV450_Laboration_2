class Api::TagController < ApplicationController

  protect_from_forgery with: :null_session
  rescue_from ActionController::UnknownFormat, with: :raise_bad_format
  before_action :api_authentication, only: [:index, :show]
  before_action :user_authenticate, only: [:create]
  respond_to :json, :xml

  #Visar alla taggar
  def index
    tags = Tag.all
    if offset_params.present?
      tags = Event.limit(@limit).offset(@offset)
    end
    if tags.empty?
      @error = ErrorMessage.new("Could not find the Tags", "There is no Tags to be shown")
      respond_with @error, status: :ok
    else
      respond_with tags
    end
  end

  #Visar alla event som finns på en viss tag
  def show
    tag = Tag.find(params[:id])
    tag_events = tag.events
    respond_with tag_events

  rescue ActiveRecord::RecordNotFound
    @error = ErrorMessage.new("Could not find that tag. Are you using the right tag_id?", "The Tag was not found!")
    respond_with @error, status: :not_found
  end

  #Skapar en tag
  def create

    tag = Tag.new(tag_params)

    if tag.save
      respond_with tag, location: url_for([:api, tag]),status: :ok
    else
      @error = ErrorMessage.new("The tag was not found!", "Could not find resource. Are you using the right tag_id?" )
      respond_with  @error, status: :not_found
    end

  end

  private
  def tag_params
    params.require(:tags).permit(:name)
  end
end
