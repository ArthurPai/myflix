class Category < ActiveRecord::Base
  validates :name, presence: true

  has_many :videos, -> { order 'title asc' }
end