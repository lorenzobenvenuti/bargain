class Scraper < ApplicationRecord
  has_many :hosts, dependent: :destroy
  has_many :rules, dependent: :destroy

  validates_presence_of :name, :hosts, :rules
  validates_uniqueness_of :name

  scope :for_host, ->(host) { joins(:hosts).where(hosts: { host: host }).first }
end
