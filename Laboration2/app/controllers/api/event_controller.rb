class Api::EventController < ApplicationController

  respond_to :json, :xml

  rescue_from ActionController::UnknownFormat, with: :raise_bad_format
  protect_from_forgery with: :null_session

  before_action :user_authenticate, only: [:create, :update, :destroy]
  before_action :api_authentication, only: [:index, :show, :nearby]

  #Visar alla event
  def index
    @events = Event.all.order(created_at: :desc)
    #Skickar man med limit och offset så visar man så många som man vill se
    if offset_params.present?
      @events = Event.limit(@limit).offset(@offset).order(created_at: :desc)
    end

    #Skickar man in en sökning tas alla event ut som matchar det man har skrivit in
    if params[:query].present?
      @events = Event.where("description LIKE ?", "%#{params[:query]}%")
    end

    if @events.empty?
      @error = ErrorMessage.new("Could not find the Events", "There is no Events to be shown")
      respond_with @error, status: :ok
    else
      respond_with @events, status: :ok
    end

  end

  #Visar ett event
  def show
    @event = Event.find(params[:id])
    respond_with @event, status: :ok

  rescue ActiveRecord::RecordNotFound
    error = ErrorMessage.new("Could not find that Event. Are you using the right event_id?", "The Event was not found!")
    respond_with error, status: :not_found
  end

  #Skapar ett event och en tag och kopplar dem till varandra
  def create
    event = Event.new(event_params)
    event.creator_id = @creator_id
    tag = Tag.new(tag_params)
    position = Position.new(position_params)

    if Tag.find_by_name(tag.name.downcase).present?
      tag = Tag.find_by_name(tag.name.downcase)
    end

    event.tags << tag
    event.position = position
    if event.save && tag.save && position.save
      respond_with event, location: url_for([:api, event]), status: :created
    else
      error = ErrorMessage.new("Could not create the Event", "Something went wrong")
      respond_with error, status: :bad_request
    end
  end

  #Uppdaterar ett event
  def update
    event = Event.find(params[:id])

    new_event = Event.new(event_params)

    if new_event.position_id != nil
      event.position_id = new_event.position_id
    end

    if event.creator_id == @creator_id
      event.title = new_event.title
      event.description = new_event.description

      if event.save
        render json: event, status: :ok
      end

    else
      error = ErrorMessage.new("Could not find that Event. Are you using the right event_id?", "The Event could not be updated. Are you the right user?")
      render json: error, status: :not_found
    end
  end

  #Tar bort ett event
  def destroy
    event = Event.find(params[:id])

    if event.creator_id == @creator_id
      event.destroy
      render json: { success: 'The Event was deleted'}, status: :ok
    else
      error = ErrorMessage.new("Could not find that Event. Are you using the right event_id?", "The Event could not be deleted. Are you the right user?")
      render json: error, status: :not_found
    end
  end

  #Denna metod använder sig av geocoder och hjälper till med sökningen nära en specifik position
  def nearby
    #Kontrollerar parametrarna
    if params[:long].present? && params[:lat].present?

      #Använder parametrarna och offset/limit
      position = Position.near([params[:long].to_f, params[:lat].to_f], 1000).limit(@limit).offset(@offset)

      #Loopar igenom alla positioner och presenterar dem
      respond_with position.flat_map(&:events), status: :ok
    else

      error = ErrorMessage.new("Could not find any resources. Bad parameters?", "Could not find any events!" )
      render json: error, status: :bad_request # just json in this example
    end
  end

  private
  def event_params
    params.require(:event).permit(:title, :description)
  end

  private
  def tag_params
    params.require(:tags).permit(:name)
  end

  private
  def position_params
    params.require(:position).permit(:long, :lat)
  end
end
