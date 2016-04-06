class PurchaseOrdersController < ApplicationController

  def new
    @purchase_order = PurchaseOrder.new
    @vendors = vendors
    @vendor = User.new
  end

  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    if @purchase_order.save
      redirect_to edit_purchase_order_path(@purchase_order)
    else
      render :new
    end
  end

  def show
    @purchase_order = PurchaseOrder.find(params[:id])
    @items = @purchase_order.items
  end

  def edit
    @purchase_order = PurchaseOrder.find(params[:id])
    gon.items = build_json_for_items
    gon.purchaseOrderId = @purchase_order.id
  end

  def create_vendor
    @vendor = User.new(user_params)
    @vendor.skip_password_validation = true
    @vendor.role = "vendor"
    if @vendor.save
      @purchase_order = PurchaseOrder.new(vendor: @vendor, created_by: current_user)
      if @purchase_order.save
        redirect_to edit_purchase_order_path(@purchase_order)
      else
        redirect_to :back
      end
    else
      flash[:alert] = @vendor.errors.full_messages.uniq.join
      redirect_to new_purchase_order_path
    end
  end

  def add_existing_item
    @item = Item.find(params[:item][:id])
    if @item.update(item_params)
      respond_to do |format|
        format.js do
          @purchase_order = @item.purchase_order
          render :'purchase_orders/add_item'
        end
      end
    end
  end

  private

  def vendors
    @vendors = User.vendor.map do |vendor|
      [vendor.full_name, vendor.id]
    end
  end

  def items
    @items = Item.potential.map do |item|
      [item.name, item.id]
    end
  end

  protected

  def purchase_order_params
    params.require(:purchase_order).permit([:vendor_id, :created_by_id])
  end

  def user_params
    params.require(:user).permit([:email, :first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext])
  end

  def item_params
    params.require(:item).permit([:purchase_order_id])
  end

  def build_json_for_items
    Item.potential.map do |item|
      {
        text: item.name,
        value: item.id,
        selected: false,
        description: item.description,
        imageSrc: item.initial_photos.first.try(:thumb).try(:url)
      }
    end.to_json
  end

end
