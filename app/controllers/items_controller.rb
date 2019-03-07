class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy, :price]

  def index
    render json: Item.all, status: :ok
  end

  def create
    @item = Item.new(item_params)
    update_notifications
    @item.save!
    render json: @item, status: :created
  end

  def show
    render json: @item, status: :ok
  end

  def update
    update_notifications
    @item.update!(item_params)
    head :no_content
  end

  def destroy
    @item.destroy
    head :no_content
  end

  def price
    host = URI(@item.url).host
    result = ScraperService.for_host(host).get_price(@item.url)
    render json: { price: result }, status: :ok
  end

  private

  def update_notifications
    notifications = notifications_params[:notifications]
    params_to_associations(notifications, @item.notifications) do |n|
      Notification.new(n)
    end
  end

  def item_params
    params.permit(:name, :url)
  end

  def notifications_params
    params.permit(notifications: [:notification_type, :notification_args, :threshold])
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
