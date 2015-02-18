module ErrorsHelper
  def raise_bad_format
    @error = ErrorMessage.new("The API does not support the requested format?", "There was a bad call. Contact the developer!" )
    # See documentation for diffrent status codes
    render json: @error, status: :bad_request
  end
  class ErrorMessage
    def initialize(dev_mess, usr_mess)
      # This is going to be json...camelcase
      @developer_message = dev_mess
      @user_message = usr_mess
    end

    # This is a custom class so we dont have the xml serializer included.
    # I wrote an own to_xml (will be called by framework)
    # There is probably a gem for that!?!
    def to_xml(options={})
      str = "<error>"
      str += "  <developerMessage>#{@developerMessage}</developerMessage>"
      str += "  <userMessage>#{@userMessage}</userMessage>"
      str += "</error>"
    end
  end
end
