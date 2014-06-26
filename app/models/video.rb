class Video < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :category
end