class ApplicationController < ActionController::API

  before_action :authorized
  before_action :set_response
  before_action :logs
    
  def encode_token(payload)
    JWT.encode(payload, 'Uu!A!@2O2!')
  end
      
  def auth_header
    request.headers['Authorization']
  end
      
  def decoded_token
    if auth_header
      begin
        decode = JWT.decode(auth_header, 'Uu!A!@2O2!', true, algorithm: 'HS256')
        return decode.first
      rescue JWT::DecodeError
        {}
      end
    end
  end
    
  def logged_in_user
    user_id = decoded_token['user_id'] if decoded_token.present?
    @user = User.find_by(id: user_id)
  end
    
  def logged_in?
    !!logged_in_user
  end
    
  def authorized
    response_method(false,'Please log in') unless logged_in?
    response = ResponsesEngine.build!(params) unless logged_in?
    render json: response, status: response[:code] unless logged_in?
  end
    
  private
  
    def badRequest(validate)
      response_method(false,validate)
      response         = ResponsesEngine.build!(params)
      return response
    end

    def response_method(status, data)
      params[:data] = {} if params[:data].nil?
      if status
        params[:data][:code]  = 200
        params[:data]['data'] = data
      else
        params[:data][:code]    = 400
        params[:data][:errors]  = [data]
        params[:data][:message] = data
      end
    end
    
    def logs
      params[:method]     = request.env['REQUEST_METHOD']
      params[:url_path]   = request.url
      params[:request_id] = request.request_id
      params[:request_ip] = request.remote_ip
      uri                 = URI(params[:url_path])
      params[:get_host]   = "#{uri.scheme}://#{uri.host}"
    end
      
      
    def set_response
      params[:data] = {}
    end
end
