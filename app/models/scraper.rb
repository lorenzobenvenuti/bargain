class Scraper < ApplicationRecord
  has_many :hosts, dependent: :destroy

  validates_presence_of :name, :price_selector, :hosts
  validates_uniqueness_of :name
end
