class Api::CreatorController < ApplicationController

  respond_to :json, :xml

  def index
    creator = Creator.all
    respond_with creator
  end

  def show
    creator = Creator.find(params[:id])
    creator_events = creator.events
    respond_with creator_events
  end

  def search
    creator = Creator.find_by_name(params[:name])
    creator_events = creator.events
    respond_with creator_events
  end
end
