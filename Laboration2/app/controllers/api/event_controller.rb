class Api::EventController < ApplicationController

  respond_to :json, :xml

  rescue_from ActionController::UnknownFormat, with: :raise_bad_format

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
    @error = ErrorMessage.new("Could not find that Event. Are you using the right event_id?", "The Event was not found!")
    respond_with @error, status: :not_found
  end

  def create

  end
end
