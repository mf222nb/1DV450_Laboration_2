class Api::EventController < ApplicationController

  respond_to :json, :xml

  rescue_from ActionController::UnknownFormat, with: :raise_bad_format
  protect_from_forgery with: :null_session

  before_action :api_authentication

  def index
    @events = Event.all.order(created_at: :desc)

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
    if event.save
      respond_with event, location: url_for([:api, event]), status: :created
    else
      error = ErrorMessage.new("Could not find that Event. Are you using the right event_id?", "Something went wrong")
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

  private
  def event_params
    params.require(:event).permit(:creator_id, :position_id, :description)
  end
end
