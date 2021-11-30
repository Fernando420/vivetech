class Api::V1::ProductsController < ApplicationController

  before_action :set_product, only: [:show]

  def index
    products = @user.products.as_json(include: [:variants])
    response_method(true, products)
    response = ResponsesEngine.build!(params)
    render json: response, status: response[:code]
  end
  
  def show
    response_method(true, @product.as_json(include: [:variants]))
    response = ResponsesEngine.build!(params)
    render json: response, status: response[:code]
  end
  
  def create
    validate = ValidateSchemas.create_product(request.request_parameters)
    return render json: badRequest(validate) if !validate.empty?
    product = @user.products.create(product_params)
    if product.valid?
      UploadVariants.delay.save_variants(product,params[:variants])
      response_method(true, product)
    else
      response_method(false, product.errors.full_messages)
    end
    response = ResponsesEngine.build!(params)
    render json: response, status: response[:code]
  end
  
  private
  
    def set_product
      @product = @user.products.find_by(id: params[:id])
      if @product.nil?
        response_method(false, "Product not found or Product Selled")
        response = ResponsesEngine.build!(params)
        render json: response, status: response[:code]
      end
    end

    def product_params
      params.permit(:name,:description)
    end

end
