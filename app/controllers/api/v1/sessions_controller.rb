class Api::V1::SessionsController < ApplicationController

  skip_before_action :authorized, only: [:login]
  
  # LOGGING IN
  def login
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      token = encode_token({user_id: user.id})
      user.update_columns(last_sign_in_at: Time.now,sign_in_count: (user.sign_in_count.to_i + 1))
      response_method(true,{token: token,id: user.id, username: user.username})
    else
      response_method(false, "Invalid username or password")
    end
    response = ResponsesEngine.build!(params)
    render json: response, status: response[:code]
  end

  # Validate token
  def validate
    response_method(true,'Token Valid')
    response = ResponsesEngine.build!(params)
    render json: response, status: response[:code]
  end

end
