class DealsController < ApplicationController
  def index
    @deals = Deal.all
  end

  def show
    @deal = Deal.find(params[:id])
  end

  def create
    @deal = Deal.new
    @product = Product.find(params[:product_id])
    @product.available = false
    @deal.user = current_user
    @deal.product = @product
    @product.save!
    @deal.save!
    redirect_to deal_path(@deal)
  end
end
