class Link < ApplicationRecord

  validates :link_id, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
  validates :shorter_url, presence: true, uniqueness: true
  validates :click_count, presence: true, numericality: { only_integer: true, greater_than: -1 }
end
