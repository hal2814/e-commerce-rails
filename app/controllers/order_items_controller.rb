class OrderItemsController < ApplicationController

  def create
    @order = current_order
    if @order.order_items.exists?(:product_id => item_params[:product_id])
      @item = @order.order_items.where(:product_id => item_params[:product_id])
      quan = @item.first.quantity += item_params[:quantity].to_i
      @item.update(:quantity => quan)
      @order.save
      session[:order_id] = @order.id
      redirect_to products_path
    else
      @item = @order.order_items.new(item_params)
      @order.account_id = current_user.id
      @order.save
      session[:order_id] = @order.id
      redirect_to products_path
    end
  end

  def destroy
    @order = current_order
    @item = @order.order_items.find(params[:id])
    @item.destroy
    @order.save
    redirect_to '/'
  end

  private

  def item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
