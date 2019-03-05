class Host < ApplicationRecord
  belongs_to :scraper

  validates_presence_of :host
  validates_uniqueness_of :host
end
