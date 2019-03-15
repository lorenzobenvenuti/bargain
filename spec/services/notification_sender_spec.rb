require File.dirname(__FILE__) + '/../../app/services/notification_sender'

describe NotificationSender do
  let(:sender1) { double() }

  let(:sender2) { double() }

  let(:notification1) { Notification.new(threshold: 100) }

  let(:notification2) { Notification.new(threshold: 110) }

  let(:factory) do
    factory = double()
    allow(factory).to receive(:notification_sender).with(notification1).and_return(sender1)
    allow(factory).to receive(:notification_sender).with(notification2).and_return(sender2)
    factory
  end

  describe '#send' do
    it "sends notifications when price goes below threshold" do
      item = Item.new(last_price: 105, notifications: [notification1, notification2])
      expect(sender1).not_to receive(:send_below_threshold)
      expect(sender1).not_to receive(:send_above_threshold)
      expect(sender2).to receive(:send_below_threshold).with(item)
      sut = NotificationSender.new(item, factory)
      sut.send(115)
    end

    it "sends both above and below threshold notifications" do
      item = Item.new(last_price: 105, notifications: [notification1, notification2])
      expect(sender1).to receive(:send_above_threshold).with(item)
      expect(sender2).to receive(:send_below_threshold).with(item)
      sut = NotificationSender.new(item, factory)
      sut.send(95)
    end

    it "sends notifications when price goes above threshold" do
      item = Item.new(last_price: 115, notifications: [notification1, notification2])
      expect(sender1).not_to receive(:send_below_threshold)
      expect(sender1).not_to receive(:send_above_threshold)
      expect(sender2).to receive(:send_above_threshold).with(item)
      sut = NotificationSender.new(item, factory)
      sut.send(105)
    end

    it "sends both above threshold notifications" do
      item = Item.new(last_price: 115, notifications: [notification1, notification2])
      expect(sender1).to receive(:send_above_threshold).with(item)
      expect(sender2).to receive(:send_above_threshold).with(item)
      sut = NotificationSender.new(item, factory)
      sut.send(95)
    end
  end
end
