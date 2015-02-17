class Api::EventController < ApplicationController

  respond_to :json, :xml

  def index
    @events = Event.all.order(created_at: :desc)
    respond_with @events
  end

  def show
    @event = Event.find_by_id(params[:id])
    respond_with @event
  end

  def create

  end
end
