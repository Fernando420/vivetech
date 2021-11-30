class Api::V1::OrdersController < ApplicationController
  
  before_action :set_order, only: [:show]
  
  def index
    orders = @user.orders
    response_method(true, orders)
    response = ResponsesEngine.build!(params)
    render json: response, status: response[:code]
  end
      
  def show
    response_method(true, @order.as_json(include: [:products]))
    response = ResponsesEngine.build!(params)
    render json: response, status: response[:code]
  end
  
  def create
    validate = ValidateSchemas.create_order(request.request_parameters)
    return render json: badRequest(validate) if !validate.empty?
    order = @user.orders.create()
    if order.valid?
      UploadProducts.delay.save_product(request.parameters[:data],@user,order)
      response_method(true, order)
    else
      response_method(false, order.errors.full_messages)
    end
    response = ResponsesEngine.build!(params)
    render json: response, status: response[:code]
  end

  private
  
    def set_order
      @order = @user.orders.find_by(id: params[:id])
      if @order.nil?
        response_method(false, "order not found")
        response = ResponsesEngine.build!(params)
        render json: response, status: response[:code]
      end
    end
  

end
