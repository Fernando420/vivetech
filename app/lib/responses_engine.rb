class ResponsesEngine

  def self.build!(*args)
    new(*args).build
  end

  def initialize(args)
    @args = args
    @data = @args[:data]
  end

  def build
    return response_success if @data[:code] == 200
    response_error
  end

  def response_error
    {
      code:       400,
      request_id: @args[:request_id],
      request_ip: @args[:request_ip],
      url:        @args[:get_host],
      status:     false,
      method:     @args[:method],
      service:    @args[:controller],
      errors:     @data[:errors],
      message:    @data[:message]
    }
  end

  def response_success
    {
      code:       200,
      request_id: @args[:request_id],
      request_ip: @args[:request_ip],
      url:        @args[:get_host],
      status:     true,
      method:     @args[:method],
      service:    @args[:controller],
      data:       @data[:data] ||= @data['data']
    }
  end

end
