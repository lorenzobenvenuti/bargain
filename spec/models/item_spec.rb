require 'rails_helper'

describe Item do
  describe '#price_must_be_calculated?' do
    let(:item) { Item.new(name: 'An item', interval: 30) }

    it 'returns true for any date if price has never been calculated' do
      expect(item.price_must_be_calculated?(Time.at(0))).to be true
      expect(item.price_must_be_calculated?(Time.new(2020, 1, 3))).to be true
      expect(item.price_must_be_calculated?(Time.now)).to be true
    end

    it 'returns true if price has been updated outside the time interval' do
      item.last_price_update = Time.new(2019, 3, 14, 11, 00)
      expect(item.price_must_be_calculated?(Time.new(2019, 3, 14, 11, 31))).to be true
      expect(item.price_must_be_calculated?(Time.new(2019, 3, 15, 11, 00))).to be true
    end

    it 'returns false if price has been updated within the time interval' do
      item.last_price_update = Time.new(2019, 3, 14, 11, 00)
      expect(item.price_must_be_calculated?(Time.new(2018, 3, 14, 11, 01))).to be false
      expect(item.price_must_be_calculated?(Time.new(2019, 3, 14, 11, 01))).to be false
      expect(item.price_must_be_calculated?(Time.new(2019, 3, 14, 11, 29))).to be false
    end
  end
end
