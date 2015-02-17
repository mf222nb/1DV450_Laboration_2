class Api::TagController < ApplicationController

  respond_to :json, :xml

  def index
    @tags = Tag.all
    respond_with @tags
  end

  def show
    tag = Tag.find(params[:id])
    tag_events = tag.events
    respond_with tag_events
  end
end
