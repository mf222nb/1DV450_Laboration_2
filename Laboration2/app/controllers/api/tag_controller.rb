class Api::TagController < ApplicationController

  respond_to :json, :xml

  rescue_from ActionController::UnknownFormat, with: :raise_bad_format

  before_action :api_authentication

  def index
    tags = Tag.all

    if tags.empty?
      @error = ErrorMessage.new("Could not find the Tags", "There is no Tags to be shown")
      respond_with @error, status: :ok
    else
      respond_with tags
    end
  end

  def show
    tag = Tag.find(params[:id])
    tag_events = tag.events
    respond_with tag_events

  rescue ActiveRecord::RecordNotFound
    @error = ErrorMessage.new("Could not find that tag. Are you using the right tag_id?", "The Tag was not found!")
    respond_with @error, status: :not_found
  end
end
