class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :product_find, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      @products = Product.where("name ILIKE ? OR description ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%").page params[:page]
    else
      @products = Product.where(available: true).page params[:page]
    end
  end

  def show
    @similar_products = Product.where("name ILIKE ? AND id <> ?", "%#{@product.name}%", "#{@product.id}").first(3)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.owner = current_user
    if @product.save
      redirect_to product_path(@product)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @product = Product.find(params[:id])
      if @product.update(product_params)
        redirect_to product_path(@product)
      else
        render :edit
      end
  end

  def destroy
    if @product.owner == current_user
    @product.destroy
    redirect_to products_path, notice: 'Produto excluído com sucesso'
    else
    redirect_to products_path, alert: 'Não autorizado'
    end
  end

  private

  def product_find
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :brand, :price, photos: [])
  end
end
