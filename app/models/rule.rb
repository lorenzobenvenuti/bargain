class Rule < ApplicationRecord
  belongs_to :scraper

  validates :rule_type, inclusion: { in: %w(css xpath text attr sub) }
end
