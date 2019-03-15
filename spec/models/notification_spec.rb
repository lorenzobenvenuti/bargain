require 'rails_helper'

describe Notification do
  describe '#price_went_above_threshold?' do
    let(:notification) { Notification.new(threshold: 100) }

    it 'returns false if previous price is nil' do
      expect(notification.price_went_above_threshold?(10, nil)).to be false
      expect(notification.price_went_above_threshold?(110, nil)).to be false
    end

    it 'returns false if previous price and current price are below threshold' do
      expect(notification.price_went_above_threshold?(90, 80)).to be false
    end

    it 'returns false if previous price and current price are above threshold' do
      expect(notification.price_went_above_threshold?(120, 110)).to be false
    end

    it 'returns false if previous price was above threshold and current price is below threshold' do
      expect(notification.price_went_above_threshold?(90, 110)).to be false
    end

    it 'returns true if previous price was below threshold and current price is above threshold' do
      expect(notification.price_went_above_threshold?(110, 90)).to be true
    end
  end

  describe '#price_is_below_threshold?' do
    let(:notification) { Notification.new(threshold: 100) }

    it 'returns false if current price > threshold' do
      expect(notification.price_is_below_threshold?(110, nil)).to be false
      expect(notification.price_is_below_threshold?(110, 90)).to be false
      expect(notification.price_is_below_threshold?(110, 120)).to be false
    end

    it 'returns false if current price <= threshold and previous price equals current price' do
      expect(notification.price_is_below_threshold?(10, 10)).to be false
    end

    it 'returns false if current price <= threshold and previous price equals current price' do
      expect(notification.price_is_below_threshold?(10, 10)).to be false
    end

    it 'returns true if current price <= threshold and previous price is nil' do
      expect(notification.price_is_below_threshold?(10, nil)).to be true
    end

    it 'returns true if current price <= threshold and previous price is higher than current price' do
      expect(notification.price_is_below_threshold?(10, 15)).to be true
    end

    it 'returns true if current price <= threshold and previous price is lower than current price' do
      expect(notification.price_is_below_threshold?(10, 5)).to be true
    end
  end
end
