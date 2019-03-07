class NotificationMailer < ApplicationMailer
  default from: 'notifications@pricetracker.com'

  def above_threshold_email
    @item = params[:item]
    @notification = params[:notification]
    @price = params[:price]
    mail(to: @notification.notification_args, subject: "#{@item.name} price went UP to #{@item.last_price}")
  end

  def below_threshold_email
    @item = params[:item]
    @notification = params[:notification]
    @price = params[:price]
    mail(to: @notification.notification_args, subject: "#{@item.name} price went DOWN to #{@item.last_price}")
  end
end
