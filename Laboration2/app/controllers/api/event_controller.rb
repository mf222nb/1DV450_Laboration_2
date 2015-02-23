class Api::EventController < ApplicationController

  respond_to :json, :xml

  rescue_from ActionController::UnknownFormat, with: :raise_bad_format
  protect_from_forgery with: :null_session

  before_action :api_authentication

  def index
    @events = Event.all.order(created_at: :desc)
    if offset_params.present?
      @events = Event.limit(@limit).offset(@offset).order(created_at: :desc)
      else if params[:query].present?
          @events = Event.where("description")
      end
    end
    if @events.empty?
      @error = ErrorMessage.new("Could not find the Events", "There is no Events to be shown")
      respond_with @error, status: :ok
    else
      respond_with @events
    end

  end

  def show
    @event = Event.find(params[:id])
    respond_with @event

  rescue ActiveRecord::RecordNotFound
    error = ErrorMessage.new("Could not find that Event. Are you using the right event_id?", "The Event was not found!")
    respond_with error, status: :not_found
  end

  def create
    event = Event.new(event_params)
    tag = Tag.new(tag_params)
    if Tag.find_by_name(tag.name).present?
      tag = Tag.find_by_name(tag.name)
    end
    event.tags << tag
      if event.save && tag.save
      respond_with event, location: url_for([:api, event]), status: :created
    else
      error = ErrorMessage.new("Could not create the Event", "Something went wrong")
      respond_with error, status: :bad_request
    end
  end

  def update
    event = Event.find(params[:id])

    new_event = Event.new(event_params)

    event.position_id = new_event.position_id
    event.description = new_event.description

    event.save

    render json: event, status: :ok

    rescue ActiveRecord::RecordNotFound
    error = ErrorMessage.new("Could not find that Event. Are you using the right event_id?", "The Event was not found!")
    render json: error, status: :not_found
  end

  def destroy
    event = Event.find(params[:id])

    event.destroy
    render json: 'The Event was deleted', status: :ok

    rescue ActiveRecord::RecordNotFound
    error = ErrorMessage.new("Could not find that Event. Are you using the right event_id?", "The Event was not found!")
    render json: error, status: :not_found

  end

  # This method is using the geocoder and helps with searching near a specific position
  def nearby

    # Check the parameters
    if params[:long].present? && params[:lat].present?

      # using the parameters and offset/limit
      position = Position.near([params[:long].to_f, params[:lat].to_f], 20).limit(@limit).offset(@offset)

      respond_with position.map(&:events), status: :ok
    else

      error = ErrorMessage.new("Could not find any resources. Bad parameters?", "Could not find any events!" )
      render json: error, status: :bad_request # just json in this example
    end

  end

  private
  def event_params
    params.require(:event).permit(:creator_id, :position_id, :description)
  end

  private
  def tag_params
    params.require(:tags).permit(:name)
  end
end
